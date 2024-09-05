# frozen_string_literal: true

class AddUniqueIndexToProductsUrlHash < ActiveRecord::Migration[7.1]
  def change
    add_index :products, :url_hash, unique: true
  end
end
