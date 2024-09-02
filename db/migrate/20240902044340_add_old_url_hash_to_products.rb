class AddOldUrlHashToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :old_url_hash, :string
  end
end
