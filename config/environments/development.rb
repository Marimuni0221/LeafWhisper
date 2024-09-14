# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.enable_reloading = true

  config.eager_load = false

  config.consider_all_requests_local = true

  config.server_timing = true

  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  config.active_storage.service = :amazon

  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.perform_caching = false

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'smtp.gmail.com',
    port: 587,
    user_name: ENV.fetch('GMAIL_USERNAME', nil),
    password: ENV.fetch('GMAIL_PASSWORD', nil),
    authentication: :plain,
    enable_starttls_auto: true
  }

  config.active_support.deprecation = :log

  config.active_support.disallowed_deprecation = :raise

  config.active_support.disallowed_deprecation_warnings = []

  config.active_record.migration_error = :page_load

  config.active_record.verbose_query_logs = true

  config.active_job.verbose_enqueue_logs = true

  config.assets.quiet = true

  config.assets.debug = true

  config.assets.check_precompiled_asset = false

  config.action_controller.raise_on_missing_callback_actions = true

  config.cache_store = :memory_store
  Rails.application.config.session_store :active_record_store, key: '_leaf_whisper_session'

  config.active_record.cache_versioning = false
end
