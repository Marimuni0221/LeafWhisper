class AddIndexToCavesPlaceId < ActiveRecord::Migration[7.1]
  def change
    add_index :caves, :place_id, unique: true
  end
end
