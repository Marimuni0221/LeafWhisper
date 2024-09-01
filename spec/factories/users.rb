# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'nickname' }
    email { 'test@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
