class CreateCafes < ActiveRecord::Migration[7.1]
  def change
    create_table :cafes do |t|
      t.string :name
      t.string :address
      t.string :phone_number
      t.string :cafe_url
      t.string :cafe_image_url
      t.string :place_id  # Google Maps API の一意の識別子
      t.float :latitude    # 緯度
      t.float :longitude   # 経度

      t.timestamps
    end
  end
end
