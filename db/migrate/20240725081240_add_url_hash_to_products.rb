class AddUrlHashToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :url_hash, :string
  end
end
