# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザー認証機能' do
  context 'when ユーザー新規登録時' do
    let(:valid_user) do
      { nickname: 'nickname', email: 'test@example.com', password: 'password', password_confirmation: 'password' }
    end
    let(:invalid_email_user) do
      { nickname: 'nickname', email: 'invalid_email', password: 'password', password_confirmation: 'password' }
    end
    let(:mismatched_password_user) do
      { nickname: 'nickname', email: 'test@example.com', password: 'password',
        password_confirmation: 'differentpassword' }
    end

    before do
      visit new_user_registration_path
    end

    it 'ユーザー登録ページにアクセスできる' do
      expect(page).to have_content('新規登録')
    end

    context 'when 正しい情報を入力した場合' do
      before do
        fill_in 'ニックネーム', with: valid_user[:nickname]
        fill_in 'メールアドレス', with: valid_user[:email]
        fill_in 'パスワード', with: valid_user[:password]
        fill_in 'パスワード（確認用）', with: valid_user[:password_confirmation]
        click_link_or_button '登録する'
      end

      it '登録成功メッセージが表示される' do
        expect(page).to have_text('アカウント登録が完了しました')
      end
    end

    context 'when 不正なメールアドレスを使用した場合' do
      before do
        fill_in 'ニックネーム', with: invalid_email_user[:nickname]
        fill_in 'メールアドレス', with: invalid_email_user[:email]
        fill_in 'パスワード', with: invalid_email_user[:password]
        fill_in 'パスワード（確認用）', with: invalid_email_user[:password_confirmation]
        click_link_or_button '登録する'
      end

      it '不正なメールアドレスのエラーメッセージが表示される' do
        expect(page).to have_text('Eメールは不正な値です')
      end
    end

    context 'when パスワードが一致しない場合' do
      before do
        fill_in 'ニックネーム', with: mismatched_password_user[:nickname]
        fill_in 'メールアドレス', with: mismatched_password_user[:email]
        fill_in 'パスワード', with: mismatched_password_user[:password]
        fill_in 'パスワード（確認用）', with: mismatched_password_user[:password_confirmation]
        click_link_or_button '登録する'
      end

      it 'パスワード不一致のエラーメッセージが表示される' do
        expect(page).to have_text('パスワードが一致しません。確認用パスワードをもう一度入力してください。')
      end
    end
  end

  context 'when ユーザーログイン時' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    it 'ログインが成功する' do
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      within('#login_button_id') { click_link_or_button 'ログイン' }
      expect(page).to have_text('ログインしました。')
    end

    it 'ログインが失敗する' do
      fill_in 'メールアドレス', with: 'wrong@example.com'
      fill_in 'パスワード', with: 'wrongpassword'
      within('#login_button_id') { click_link_or_button 'ログイン' }
      expect(page).to have_text('Eメールまたはパスワードが違います。')
    end
  end
end
