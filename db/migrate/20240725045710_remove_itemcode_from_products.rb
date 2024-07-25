class RemoveItemcodeFromProducts < ActiveRecord::Migration[7.1]
  def change
    remove_column :products, :item_code, :string
  end
end
