require 'rails_helper'

describe "パスワードリセット", type: :request do
  it "パスワードリセットのメールを送信する" do
    user = FactoryBot.create(:user)
    post user_password_path, params: { user: { email: user.email } }
    expect(ActionMailer::Base.deliveries.size).to eq(1)
    expect(response).to redirect_to(new_user_session_path)
  end

  it "パスワードをリセットする" do
    user = FactoryBot.create(:user)
    token = user.send(:set_reset_password_token)
    put user_password_path, params: { user: { reset_password_token: token, password: "newpassword", password_confirmation: "newpassword" } }
    expect(response).to redirect_to(user_session_path)
  end
end