# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'パスワードリセット' do
  include Devise::Test::IntegrationHelpers

  it 'パスワードリセットのメールが送信されることを確認する' do
    user = create(:user)
    post user_password_path, params: { user: { email: user.email } }
    expect(ActionMailer::Base.deliveries.size).to eq(1)
  end

  it 'パスワードリセットのリダイレクトを確認する' do
    user = create(:user)
    post user_password_path, params: { user: { email: user.email } }
    expect(response).to redirect_to(new_user_session_path)
  end

  it 'パスワードをリセットする' do
    user = create(:user)
    token = user.send(:set_reset_password_token)
    put user_password_path,
        params: { user: { reset_password_token: token, password: 'newpassword', password_confirmation: 'newpassword' } }
    expect(response).to redirect_to(root_path)
  end
end
