# frozen_string_literal: true

require 'rails_helper'

# frozen_string_literal: true

RSpec.describe StaticPagesController do
  include Devise::Test::ControllerHelpers

  describe 'GET #terms' do
    it '利用規約の画面を表示' do
      get :terms
      expect(response).to render_template(:terms)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #privacy' do
    it 'プライバシーポリシーの画面を表示' do
      get :privacy
      expect(response).to render_template(:privacy)
      expect(response).to have_http_status(:success)
    end
  end
end
