# frozen_string_literal: true

require "rails"
require_relative "adapters/active_support_notifications"
require_relative "subscriber_registry"
require_relative "configuration"
require_relative "subscriber"

module ActivePubsubRails
  class Engine < ::Rails::Engine
    initializer "active_pubsub_rails.initialize_subscribers" do |app|
      app.reloader.to_prepare do
        ActivePubsubRails.activate_autoloadable_subscribers
      end

      app.reloader.before_class_unload do
        ActivePubsubRails.deactivate_all_subscribers
      end
    end
  end
end
