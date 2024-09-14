# frozen_string_literal: true

class AvatarUploader < CarrierWave::Uploader::Base
  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url(*_args)
    ActionController::Base.helpers.asset_path('default_avatar.png')
  end

  def extension_allowlist
    %w[jpg jpeg gif png]
  end
end
