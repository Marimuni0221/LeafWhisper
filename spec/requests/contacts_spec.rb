# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'お問い合わせ' do
  describe 'GET /new' do
    it 'ステータスコード200が返る' do
      get new_contact_path
      expect(response).to have_http_status(:ok)
    end

    it 'お問い合わせページの内容を表示する' do
      get new_contact_path
      expect(response.body).to include('お問い合わせ')
    end
  end

  describe 'POST/contacts' do
    context 'when 正常なパラメータを使用した場合' do
      it 'お問い合わせメールが送信される' do
        expect do
          post contacts_path,
               params: { contact: { name: 'Test User', email: 'test@example.com', message: 'This is a test message.' } }
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'お問い合わせ送信後、リダイレクトされる' do
        post contacts_path,
             params: { contact: { name: 'Test User', email: 'test@example.com', message: 'This is a test message.' } }
        expect(response).to redirect_to(new_contact_path)
      end

      it 'リダイレクト後、お問い合わせ送信完了メッセージが表示される' do
        post contacts_path,
             params: { contact: { name: 'Test User', email: 'test@example.com', message: 'This is a test message.' } }
        follow_redirect!
        expect(response.body).to include('お問い合わせが送信されました。')
      end
    end

    context 'when 不正なパラメータを使用した場合' do
      it 'お問い合わせメールが送信されない' do
        expect do
          post contacts_path, params: { contact: { name: '', email: '', message: '' } }
        end.not_to(change { ActionMailer::Base.deliveries.count })
      end

      it '名前のエラーメッセージが表示される' do
        post contacts_path, params: { contact: { name: '', email: '', message: '' } }
        expect(response.body).to include('名前を入力してください')
      end

      it 'メールアドレスのエラーメッセージが表示される' do
        post contacts_path, params: { contact: { name: '', email: '', message: '' } }
        expect(response.body).to include('メールアドレスを入力してください')
      end

      it 'メッセージのエラーメッセージが表示される' do
        post contacts_path, params: { contact: { name: '', email: '', message: '' } }
        expect(response.body).to include('メッセージを入力してください')
      end
    end
  end
end
