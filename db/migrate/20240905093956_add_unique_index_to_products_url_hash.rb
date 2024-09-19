# frozen_string_literal: true

class AddUniqueIndexToProductsUrlHash < ActiveRecord::Migration[7.1]
  def change
    remove_index :products, :url_hash if index_exists?(:products, :url_hash)
    remove_index :products, :item_url if index_exists?(:products, :item_url)

    add_index :products, :url_hash, unique: true
    add_index :products, :item_url, unique: true
  end
end
