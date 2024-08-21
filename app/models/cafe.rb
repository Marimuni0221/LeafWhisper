class Cafe < ApplicationRecord
  self.table_name = 'cave'
  has_many :favorites, as: :favoritable, dependent: :destroy
end
