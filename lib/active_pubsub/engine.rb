# frozen_string_literal: true

require_relative "adapters/active_support_notifications"
require_relative "subscriber_registry"
require_relative "configuration"
require_relative "subscriber"

module ActivePubsub
  class Engine < ::Rails::Engine
    initializer "spree.core.initialize_subscribers" do |app|
      app.reloader.to_prepare do
        ActivePubsub.activate_autoloadable_subscribers
      end

      app.reloader.before_class_unload do
        ActivePubsub.deactivate_all_subscribers
      end
    end
  end
end
