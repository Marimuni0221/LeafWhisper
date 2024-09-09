# frozen_string_literal: true

class AddUniqueIndexToProductsUrlHash < ActiveRecord::Migration[7.1]
  def change
    # 既存のインデックスを削除（もし存在する場合）
    remove_index :products, :url_hash if index_exists?(:products, :url_hash)
    remove_index :products, :item_url if index_exists?(:products, :item_url)

    # ユニークインデックスを追加
    add_index :products, :url_hash, unique: true
    add_index :products, :item_url, unique: true
  end
end
