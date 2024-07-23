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
      ['〜500円', 'under_500'],
      ['500円〜1000円', '500_to_1000'],
      ['1000円〜2000円', '1000_to_2000'],
      ['2000円〜3000円', '2000_to_3000'],
      ['3000円以上', 'above_3000']
    ]
  end

end
