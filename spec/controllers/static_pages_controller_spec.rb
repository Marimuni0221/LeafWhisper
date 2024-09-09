# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaticPagesController do
  include Devise::Test::ControllerHelpers

  describe 'GET #terms' do
    it '利用規約ページを表示する' do
      get :terms
      expect(response).to render_template(:terms)
    end

    it '利用規約ページのステータスが成功である' do
      get :terms
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #privacy' do
    it 'プライバシーポリシーページを表示する' do
      get :privacy
      expect(response).to render_template(:privacy)
    end

    it 'プライバシーポリシーページのステータスが成功である' do
      get :privacy
      expect(response).to have_http_status(:success)
    end
  end
end
