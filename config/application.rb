# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LeafWhisper
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1
    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # アプリケーションの日本語化設定
    config.i18n.default_locale = :ja
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    # アセットパイプラインが有効になっていることを確認
    config.assets.enabled = true
    # アセットロードパスにアセットを追加する
    config.assets.paths << Rails.root.join('app/assets/images')

    config.action_controller.default_protect_from_forgery = true

    config.cache_store = :redis_cache_store, {
      url: 'redis://redis:6379/0/cache',
      namespace: 'cache',
      expires_in: 90.minutes
    }
  end
end
