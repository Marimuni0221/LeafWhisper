# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FaqsController, type: :controller do
  describe 'GET #index' do
    it 'FAQの画面を表示' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it '@faqsを割り当てる' do
      get :index
      expect(assigns(:faqs)).not_to be_nil
    end
  end
end
