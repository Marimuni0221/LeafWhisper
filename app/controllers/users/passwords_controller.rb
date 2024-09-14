# frozen_string_literal: true

module Users
  class PasswordsController < Devise::PasswordsController
    def after_resetting_password_path_for(_resource)
      user_session_path
    end
  end
end
