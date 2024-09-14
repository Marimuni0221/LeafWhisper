# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    def create
      request.session_options[:store] = false
      super
    end
  end
end
