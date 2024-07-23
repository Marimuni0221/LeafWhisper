# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# ユーザーの作成
unless User.exists?(email: 'test@example.com')
  User.create!(
    email: 'test@example.com',
    password: 'password',
    password_confirmation: 'password',
    name: 'Test User'
  )
end
  
# 商品の作成
products = [
  { name: 'Sample Product', description: 'This is a sample product.', price: 100.0 },
  { name: 'Sample Matcha 1', description: 'This is a sample description for Matcha 1', price: 1000, item_url: 'https://example.com/item1', item_image_url: ActionController::Base.helpers.asset_path('matcha_powder.jpg'), category: 'tea' },
  { name: 'Sample Matcha 2', description: 'This is a sample description for Matcha 2', price: 1500, item_url: 'https://example.com/item2', item_image_url: ActionController::Base.helpers.asset_path('matcha_powder.jpg'), category: 'tea' }
]

products.each do |product|
  Product.create!(product) unless Product.exists?(name: product[:name])
end
  
