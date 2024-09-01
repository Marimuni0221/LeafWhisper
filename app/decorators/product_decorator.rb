# frozen_string_literal: true

class ProductDecorator < Draper::Decorator
  delegate_all

  def formatted_price
    h.number_to_currency(object.price)
  end

  def self.decorate_collection(products, context = {})
    products = products.price_range(context[:price_range]) if context[:price_range].present?
    super(products)
  end

  def self.category_options
    Product.categories.keys.map { |key| [I18n.t("activerecord.attributes.product.categories.#{key}"), key] }
  end

  def self.price_range_options
    [
      [I18n.t('products.price_ranges.under_500'), 'under_500'],
      [I18n.t('products.price_ranges.500_to_1000'), '500_to_1000'],
      [I18n.t('products.price_ranges.1000_to_2000'), '1000_to_2000'],
      [I18n.t('products.price_ranges.2000_to_3000'), '2000_to_3000'],
      [I18n.t('products.price_ranges.above_3000'), 'above_3000']
    ]
  end
end
