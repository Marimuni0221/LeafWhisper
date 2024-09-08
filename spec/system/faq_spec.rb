# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FAQ ページ' do
  before do
    driven_by(:selenium_chrome_headless)
  end

  it 'FAQ の質問を表示する' do
    visit faqs_path
    expect(page).to have_content('抹茶とは何ですか？')
  end

  it 'FAQ項目を展開・折りたたむ' do
    visit faqs_path
    find('input#faq-0').click(force: true)
    expect(page).to have_content('抹茶は、茶葉を細かく粉末状にしたもの')
  end
end
