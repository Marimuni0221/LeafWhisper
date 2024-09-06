class AddCaseInsensitiveIndexToProductsUrlHash < ActiveRecord::Migration[7.1]
  def change
    def up
      remove_index :products, :url_hash if index_exists?(:products, :url_hash)
      add_index :products, 'lower(url_hash)', unique: true
    end

    def down
      remove_index :products, 'lower(url_hash)'
      add_index :products, :url_hash, unique: true
    end
  end
end
