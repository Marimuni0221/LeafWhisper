# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_search
  before_action :set_locale
  before_action :store_user_location!, if: :storable_location?

  def current_user
    super&.decorate
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name avatar])
  end

  private

  # 元のページのURLを保存するメソッド
  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  # URLを保存するための条件を定義するメソッド
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  # ログイン後のリダイレクト先を指定するメソッド
  def after_sign_in_path_for(resource_or_scope)
    # 保存されたリダイレクト先がカフェ関連の場合は、カフェ検索ページにリダイレクト
    if stored_location_for(resource_or_scope)&.include?('/cafes/')
      cafes_search_path
    else
      stored_location_for(resource_or_scope) || super
    end
  end

  def set_search
    @q = Product.ransack(params[:q])
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    Rails.logger.debug { "Current locale: #{I18n.locale}" }
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
