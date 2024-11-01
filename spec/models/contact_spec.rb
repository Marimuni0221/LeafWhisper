# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact do
  subject { described_class.new(name: 'John Doe', email: 'john@example.com', message: 'Hello, this is a message.') }

  describe 'バリデーション' do
    it '全ての属性が有効な場合に有効であること' do
      expect(contact).to be_valid
    end

    it '名前がない場合は無効であること' do
      contact.name = nil
      expect(contact).not_to be_valid
    end

    it '名前がない場合はエラーメッセージが表示されること' do
      contact.name = nil
      contact.validate
      expect(contact.errors[:name]).to include("can't be blank")
    end

    it 'メールがない場合は無効であること' do
      contact.email = nil
      expect(contact).not_to be_valid
    end

    it 'メールがない場合はエラーメッセージが表示されること' do
      contact.email = nil
      contact.validate
      expect(contact.errors[:email]).to include("can't be blank")
    end

    it 'メールの形式が不正な場合は無効であること' do
      contact.email = 'invalid_email'
      expect(contact).not_to be_valid
    end

    it 'メールの形式が不正な場合はエラーメッセージが表示されること' do
      contact.email = 'invalid_email'
      contact.validate
      expect(contact.errors[:email]).to include('is invalid')
    end

    it 'メッセージがない場合は無効であること' do
      contact.message = nil
      expect(contact).not_to be_valid
    end

    it 'メッセージがない場合はエラーメッセージが表示されること' do
      contact.message = nil
      contact.validate
      expect(contact.errors[:message]).to include("can't be blank")
    end
  end
end
