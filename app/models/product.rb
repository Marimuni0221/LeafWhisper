# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :favorites, as: :favoritable, dependent: :destroy

  before_validation :generate_url_hash, if: -> { item_url.present? && item_url_changed? }
  before_save :generate_url_hash

  validates :name, presence: true
  validates :url_hash, presence: true, uniqueness: true
  # validates :item_url, presence: true, uniqueness: true

  scope :price_range, lambda { |range|
    case range
    when 'under_500'
      where(price: ...500)
    when '500_to_1000'
      where(price: 500..1000)
    when '1000_to_2000'
      where(price: 1000..2000)
    when '2000_to_3000'
      where(price: 2000..3000)
    when 'above_3000'
      where('price > ?', 3000)
    else
      all
    end
  }

  enum :category, { tea: 0, sweets: 1, gift: 2 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[category created_at description id name price updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def generate_url_hash
    self.url_hash = Digest::SHA256.hexdigest(item_url)
  end
end
