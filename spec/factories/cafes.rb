# frozen_string_literal: true

FactoryBot.define do
  factory :cafe do
    name { 'Sample Cafe' }
    address { '123 Tokyo Street' }
    phone_number { '03-1234-5678' }
    cafe_url { 'https://samplecafe.com' }
    cafe_image_url { 'https://samplecafe.com/image.jpg' }
    place_id { SecureRandom.uuid }
  end
end
