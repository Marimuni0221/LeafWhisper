# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    # You should configure your model like this:
    # devise :omniauthable, omniauth_providers: [:twitter]
    #
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
        # ユーザーが見つからなかった場合の処理
        flash[:alert] =
          "There was a problem signing you in through #{provider}. Please register or try signing in later."
        redirect_to new_user_registration_url
      end
    end
    # You should also create an action method in this controller like this:
    # def twitter
    # end

    # More info at:
    # https://github.com/heartcombo/devise#omniauth

    # GET|POST /resource/auth/twitter
    # def passthru
    #   super
    # end

    # GET|POST /users/auth/twitter/callback
    def failure
      redirect_to root_path
    end

    # protected

    # The path used when OmniAuth fails
    # def after_omniauth_failure_path_for(scope)
    #   super(scope)
    # end
  end
end
