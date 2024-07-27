class ExternalProduct
  include ActiveModel::Model
  attr_accessor :id, :name, :description, :price, :item_url, :item_image_url, :category
end
