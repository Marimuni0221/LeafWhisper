# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザー認証機能' do
  context 'ユーザー新規登録時' do
    it 'ユーザー登録成功時' do
      visit new_user_registration_path
      fill_in 'ニックネーム', with: 'nickname'
      fill_in 'Eメール', with: 'test@example.com'
      fill_in 'パスワード', with: 'password'
      fill_in 'パスワード（確認用）', with: 'password'
      click_butoon '登録する'

      expect(page).to have - text('アカウント登録が完了しました')
    end

    it '不正なメールアドレス使用時' do
      visit new_user_registration_path
      fill_in 'ニックネーム', with: 'nickname'
      fill_in 'Eメール', with: 'invalid_email'
      fill_in 'パスワード', with: 'password'
      fill_in 'パスワード（確認用）', with: 'password'
      click_butoon '登録する'

      expect(page).to have - text('メールアドレスに「@」を挿入してください。')
    end

    it '一致しないパスワード入力時' do
      visit new_user_registration_path
      fill_in 'ニックネーム', with: 'nickname'
      fill_in 'Eメール', with: 'test@example.com'
      fill_in 'パスワード', with: 'password'
      fill_in 'パスワード（確認用）', with: 'differentpassword'
      click_butoon '登録する'

      expect(page).to have - text('パスワードが一致しません。確認用パスワードをもう一度入力してください。')
    end
  end

  context 'ユーザーログイン時' do
    let(:user) { create(:user) }

    it 'ログイン成功時' do
      visit new_user_session_path
      fill_in 'Eメール', with: user.email
      fill_in 'パスワード', with: user.password
      click_butoon 'ログイン'

      expect(page).to have_text('ログインしました。')
    end

    it 'ログイン失敗時' do
      visit new_user_session_path
      fill_in 'Eメール', with: 'wrong@example.com'
      fill_in 'パスワード', with: 'wrongpassword'
      click_butoon 'ログイン'

      expect(page).to have_text('Eメールまたはパスワードが違います。')
    end
  end
end
