# frozen_string_literal: true

require_relative "active_pubsub/version"
require_relative "active_pubsub/engine"

module ActivePubsub
  extend self
  delegate :activate_autoloadable_subscribers, :activate_all_subscribers, :deactivate_all_subscribers, to: :subscriber_registry

  def fire(event_name, opts = {})
    adapter.fire normalize_name(event_name), opts do
      yield opts if block_given?
    end
  end

  def subscribe(event_name, &block)
    name = normalize_name(event_name)
    listeners_names << name
    adapter.subscribe(name, &block)
  end

  def unsubscribe(subscriber)
    name_or_subscriber = subscriber.is_a?(String) ? normalize_name(subscriber) : subscriber
    adapter.unsubscribe(name_or_subscriber)
  end

  def listeners
    adapter.listeners_for(listeners_names)
  end

  def adapter
    @adapter ||= ActivePubsub::Adapters::ActiveSupportNotifications
  end

  def subscriber_registry
    @subscriber_registry ||= ActivePubsub::SubscriberRegistry.new
  end

  private

  def normalize_name(name)
    adapter.normalize_name(name)
  end

  def listeners_names
    @listeners_names ||= Set.new
  end
end
