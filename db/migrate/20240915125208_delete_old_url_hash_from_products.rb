# frozen_string_literal: true

class DeleteOldUrlHashFromProducts < ActiveRecord::Migration[7.1]
  def change
    remove_column :products, :old_url_hash, :string
  end
end
