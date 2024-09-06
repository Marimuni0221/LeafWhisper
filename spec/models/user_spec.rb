# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'バリデーション' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'お気に入り機能' do
    let(:user) { create(:user) }
    let(:product) { create(:product) }

    it 'お気に入り追加が可能' do
      user.favorite(product)
      expect(user).to be_favorited(product)
    end

    it 'お気に入り追加が不可能' do
      user.favorite(product)
      user.unfavorite(product)
      expect(user).not_to be_favorited(product)
    end
  end

  describe '.from_omniauthメソッド' do
    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: 'google_oauth2',
        uid: '12345',
        info: { email: 'test@example.com', name: 'Test User' }
      )
    end

    it 'OAuthデータからユーザーのメールアドレスを作成または更新する' do
      user = described_class.from_omniauth(auth)
      expect(user.email).to eq('test@example.com')
    end

    it 'OAuthデータからユーザーの名前を作成または更新する' do
      user = described_class.from_omniauth(auth)
      expect(user.name).to eq('Test User')
    end
  end
end
