# frozen_string_literal: true

class AddOuthColumnToUsers < ActiveRecord::Migration[7.1]
  def change
    change_table :users, bulk: true do |t|
      t.string :provider
      t.string :uid
    end
  end
end
