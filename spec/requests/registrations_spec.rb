# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ユーザー登録' do
  include Devise::Test::IntegrationHelpers

  describe 'DELETE /users' do
    it 'アカウントを削除する' do
      user = create(:user)
      sign_in user
      delete user_registration_path
      expect(response).to redirect_to(root_path)
      expect(User).not_to exist(user.id)
    end
  end
end
