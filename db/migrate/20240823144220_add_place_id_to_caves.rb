class AddPlaceIdToCaves < ActiveRecord::Migration[7.1]
  def change
    add_column :caves, :place_id, :string
  end
end
