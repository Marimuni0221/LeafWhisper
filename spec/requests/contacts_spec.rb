# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'お問い合わせ', type: :request do
  describe 'GET /new' do
    it 'お問い合わせページを表示する' do
      get new_contact_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('お問い合わせ')
    end
  end

  describe 'POST/contacts' do
    context '正常なパラメータを使用' do
      it 'お問い合わせメールを送信する' do
        expect do
          post contacts_path,
               params: { contact: { name: 'Test User', email: 'test@example.com', message: 'This is a test message.' } }
        end.to change { ActionMailer::Base.deliveries.count }.by(1)

        expect(response).to redirect_to(new_contact_path)
        follow_redirect!
        expect(response.body).to include('お問い合わせが送信されました。')
      end
    end

    context '不正なパラメータを使用' do
      it 'お問い合わせメールは送信せず、再度お問い合わせフォームを表示する' do
        expect do
          post contacts_path, params: { contact: { name: '', email: '', message: '' } }
        end.not_to(change { ActionMailer::Base.deliveries.count })

        expect(response.body).to include('名前を入力してください')
        expect(response.body).to include('メールアドレスを入力してください')
        expect(response.body).to include('メッセージを入力してください')
      end
    end
  end
end
