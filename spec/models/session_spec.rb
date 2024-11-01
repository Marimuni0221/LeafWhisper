# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Session do
  describe 'Session management' do
    let(:user) { create(:user) }

    it 'ユーザーがログインした際にセッションがデータベースに保存されること' do
      session = described_class.create(user_id: user.id)
      expect(session).to be_persisted
    end

    it 'セッションに正しいuser_idが設定されていること' do
      session = described_class.create(user_id: user.id)
      expect(session.user_id).to eq(user.id)
    end

    it 'ユーザーがログアウトした際にセッションを破棄する' do
      session = described_class.create(user_id: user.id)
      session.destroy
      expect(described_class.find_by(id: session.id)).to be_nil
    end

    it 'user_idがない場合は無効であること' do
      session = described_class.new
      expect(session).not_to be_valid
    end

    it 'user_idがない場合のエラーメッセージが表示されること' do
      session = described_class.new
      session.validate
      expect(session.errors[:user_id]).to include("can't be blank")
    end

    it '一定時間経過後、セッションの有効期限が切れることを確認' do
      session = described_class.create(user_id: user.id, created_at: 1.day.ago)
      expect(session.expired?).to be(true)
    end
  end
end
