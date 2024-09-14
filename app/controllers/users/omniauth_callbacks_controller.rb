# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      callback_for(:google)
    end

    def callback_for(provider)
      auth = request.env['omniauth.auth']
      @user = User.from_omniauth(auth)

      if @user.present?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: provider.to_s.capitalize) if is_navigational_format?
      else
        flash[:alert] =
          "There was a problem signing you in through #{provider}. Please register or try signing in later."
        redirect_to new_user_registration_url
      end
    end

    def failure
      redirect_to root_path
    end
  end
end
