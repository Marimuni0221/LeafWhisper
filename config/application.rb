# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module LeafWhisper
  class Application < Rails::Application
    config.load_defaults 7.1

    config.autoload_lib(ignore: %w[assets tasks])

    config.i18n.default_locale = :ja
    config.i18n.available_locales = %i[ja en]

    config.assets.enabled = true

    config.assets.paths << Rails.root.join('app/assets/images')

    config.action_controller.default_protect_from_forgery = true

    config.cache_store = :redis_cache_store, {
      url: 'redis://redis:6379/0/cache',
      namespace: 'cache',
      expires_in: 90.minutes
    }
  end
end
