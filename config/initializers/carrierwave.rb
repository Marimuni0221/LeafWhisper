# frozen_string_literal: true

require 'carrierwave/orm/activerecord'
require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  if Rails.env.production?
    # 本番環境ではS3を使用
    config.storage = :fog
    config.fog_directory = 'leaf-whisper'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID', nil),
      aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY', nil),
      region: 'ap-northeast-1',
      path_style: true
    }
  else
    # 開発・テスト環境ではローカルストレージを使用
    config.storage = :file
    config.enable_processing = false if Rails.env.test? # テスト環境では画像処理を無効化
  end
end
