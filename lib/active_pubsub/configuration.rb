# frozen_string_literal: true

module ActivePubsub
  class Configuration
    def subscriber_registry
      @subscriber_registry ||= ActivePubsub::SubscriberRegistry.new
    end

    attr_writer :adapter, :autoload_subscribers

    def autoload_subscribers
      @autoload_subscribers.nil? ? true : !!@autoload_subscribers
    end

    def adapter
      @adapter ||= ActivePubsub::Adapters::ActiveSupportNotifications
    end
  end
end
