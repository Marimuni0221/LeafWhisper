# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { 'Sample Product' }
    price { 1000 }
    item_url { 'http://example.com/product' }
    url_hash { Digest::SHA256.hexdigest('http://example.com/product') }
    category { :tea }
  end
end
