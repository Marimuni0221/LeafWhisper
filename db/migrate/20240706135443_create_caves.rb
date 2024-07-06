class CreateCaves < ActiveRecord::Migration[7.1]
  def change
    create_table :caves do |t|
      t.string :name
      t.string :address
      t.string :phone_number
      t.string :cafe_url
      t.string :cafe_image_url

      t.timestamps null: false
    end
  end
end
