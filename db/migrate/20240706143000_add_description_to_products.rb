# frozen_string_literal: true

class AddDescriptionToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :description, :text
  end
end
