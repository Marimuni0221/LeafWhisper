# frozen_string_literal: true

class AddCaseInsensitiveIndexToUsersEmail < ActiveRecord::Migration[7.1]
  def change
    def up # rubocop:disable Lint/NestedMethodDefinition
      remove_index :users, :email if index_exists?(:users, :email)
      add_index :users, 'lower(email)', unique: true
    end

    def down # rubocop:disable Lint/NestedMethodDefinition
      remove_index :users, 'lower(email)'
      add_index :users, :email, unique: true
    end
  end
end
