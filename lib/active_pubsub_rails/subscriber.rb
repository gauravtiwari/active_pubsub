# frozen_string_literal: true

module ActivePubsubRails
  module Subscriber
    def self.included(base)
      base.extend base

      base.mattr_accessor :event_actions
      base.event_actions = {}

      ActivePubsubRails.subscriber_registry.register(base)
    end

    def event_action(method_name, event_name: nil)
      event_actions[method_name] = (event_name || method_name).to_s
    end

    def activate
      ActivePubsubRails.subscriber_registry.activate_subscriber(self)
    end

    def deactivate(event_action_name = nil)
      ActivePubsubRails.subscriber_registry.deactivate_subscriber(self, event_action_name)
    end
  end
end
