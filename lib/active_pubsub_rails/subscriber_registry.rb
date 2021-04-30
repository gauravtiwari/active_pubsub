# frozen_string_literal: true

module ActivePubsubRails
  class SubscriberRegistry
    def initialize
      @registry = {}
      @semaphore = Mutex.new
    end

    def register(subscriber)
      registry[subscriber.name] ||= {}
    end

    def activate_autoloadable_subscribers
      require_subscriber_files
      activate_all_subscribers
    end

    def activate_all_subscribers
      registry.each_key { |subscriber_name| activate_subscriber(subscriber_name.constantize) }
    end

    def deactivate_all_subscribers
      registry.each_key { |subscriber_name| deactivate_subscriber(subscriber_name.constantize) }
    end

    def activate_subscriber(subscriber)
      return unless registry[subscriber.name]

      subscriber.event_actions.each do |event_action, event_name|
        @semaphore.synchronize do
          unsafe_deactivate_subscriber(subscriber, event_action)
          subscription = ActivePubsubRails.subscribe(event_name) { |event| subscriber.send(event_action, event) }
          registry[subscriber.name][event_action] = subscription
        end
      end
    end

    def deactivate_subscriber(subscriber, event_action_name = nil)
      @semaphore.synchronize do
        unsafe_deactivate_subscriber(subscriber, event_action_name)
      end
    end

    private

    attr_reader :registry

    def require_subscriber_files
      pattern = "app/subscribers/**/*_subscriber.rb"
      Rails.root.glob(pattern) { |c| require_dependency(c.to_s) }
    end

    def unsafe_deactivate_subscriber(subscriber, event_action_name = nil)
      to_unsubscribe = Array.wrap(event_action_name || subscriber.event_actions.keys)

      to_unsubscribe.each do |event_action|
        next unless (subscription = registry.dig(subscriber.name, event_action))

        ActivePubsubRails.unsubscribe(subscription)

        registry[subscriber.name].delete(event_action)
      end
    end
  end
end
