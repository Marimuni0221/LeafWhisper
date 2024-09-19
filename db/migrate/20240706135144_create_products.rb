# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :price
      t.string :item_url
      t.string :item_image_url
      t.timestamps null: false
    end
  end
end
