class AddItemCodeToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :item_code, :string
    add_index :products, :item_code, unique: true
  end
end
