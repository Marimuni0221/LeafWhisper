require 'rails_helper'

# frozen_string_literal: true

Rspec.describe StaticPagesController, type: :controller do
  describe "GET #terms" do
    it "利用規約の画面を表示" do
      get :terms
      expect(response).to render_template(:terms)
      expect(response).to have_http_status(:success)
    end
  end
end
