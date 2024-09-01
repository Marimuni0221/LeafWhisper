# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Cafes', type: :request do
  describe 'GET /search' do
    it 'returns http success' do
      get '/cafes/search'
      expect(response).to have_http_status(:success)
    end
  end
end
