# frozen_string_literal: true

class AddCategoryToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :category, :integer, default: 0, null: false
  end
end
