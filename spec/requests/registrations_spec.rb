require 'rails_helper'

RSpec.describe "ユーザー登録", type: :request do
  describe "DELETE /users" do
    it "アカウントを削除する" do
      user = FactoryBot.create(:user)
      sign_in user
      delete user_registration_path
      expect(response).to redirect_to(root_path)
      expect(User.exists?(user.id)).to be_falsey
    end
  end
end