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
    name: 'Test User'
  )
end
  
  # 商品の作成
Product.create!(
  name: 'Sample Product',
  description: 'This is a sample product.',
  price: 100.0
) unless Product.exists?(name: 'Sample Product')
  
  # カフェの作成
Cafe.create!(
  name: 'Sample Cafe',
  location: 'Sample Location'
) unless Cafe.exists?(name: 'Sample Cafe')
  