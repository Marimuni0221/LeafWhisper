class Cafe < ApplicationRecord
  self.table_name = 'caves'
  has_many :favorites, as: :favoritable, dependent: :destroy
end
