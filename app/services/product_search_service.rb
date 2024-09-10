# frozen_string_literal: true

# app/services/product_search_service.rb
class ProductSearchService
  def initialize(params)
    @params = params
  end

  def call
    search
  end

  private

  def search
    @q = Product.ransack(@params[:q] || {})
    keyword = extract_keyword(@params[:q])
    category = extract_category(@params[:q])
    products = fetch_products(keyword)

    apply_filters(products, category, @params[:price_range])
  end

  def extract_keyword(query_params)
    query_params.present? ? query_params[:name_or_description_cont] : '抹茶'
  end

  def extract_category(query_params)
    query_params[:category_eq].to_sym if query_params.present? && query_params[:category_eq].present?
  end

  def apply_filters(products, category, price_range)
    products = filter_by_category(products, category) if category.present?
    products = filter_by_price_range(products, price_range) if price_range.present?
    products
  end

  def filter_by_category(products, category)
    products.select { |product| product[:category].to_sym == category }
  end

  def filter_by_price_range(products, price_range)
    products.select { |product| in_price_range?(product[:price], price_range) }
  end

  def in_price_range?(price, range)
    price_ranges = {
      'under_500' => -> { price_under_500?(price) },
      '500_to_1000' => -> { price_between?(price, 500, 1000) },
      '1000_to_2000' => -> { price_between?(price, 1000, 2000) },
      '2000_to_3000' => -> { price_between?(price, 2000, 3000) },
      'above_3000' => -> { price_above_3000?(price) }
    }

    price_ranges.fetch(range, -> { true }).call
  end

  def price_under_500?(price)
    price < 500
  end

  def price_between?(price, min, max)
    price >= min && price <= max
  end

  def price_above_3000?(price)
    price > 3000
  end

  def fetch_products(keyword)
    keyword = adjust_keyword(keyword)
    items = search_rakuten_items(keyword)
    items.map { |item| build_product(item) }
  end

  def search_rakuten_items(keyword)
    items = []
    (1..5).each do |i|
      result = RakutenWebService::Ichiba::Item.search(keyword:, page: i)
      break if result.count.zero?

      items.concat(result.to_a)
    end
    items
  end

  def adjust_keyword(keyword)
    return I18n.t('products.default_keyword') if keyword.blank?

    keyword.exclude?(I18n.t('products.default_keyword')) ? "#{keyword} #{I18n.t('products.default_keyword')}" : keyword
  end

  def build_product(item)
    product = find_or_initialize_product(item['itemUrl'])
    assign_product_attributes(product, item)
    product
  end

  def find_or_initialize_product(item_url)
    url_hash = generate_url_hash(item_url)
    Product.find_or_initialize_by(url_hash:)
  end

  def generate_url_hash(item_url)
    Digest::SHA256.hexdigest(item_url)
  end

  def assign_product_attributes(product, item)
    product.assign_attributes(
      name: item['itemName'],
      description: item['itemCaption'],
      price: item['itemPrice'],
      item_url: item['itemUrl'],
      item_image_url: item['mediumImageUrls'].first,
      category: determine_category(item['itemName'], item['itemCaption'])
    )
    product.save!
  end

  def determine_category(name, description)
    if name.include?('スイーツ') || description.include?('スイーツ')
      'sweets'
    elsif name.include?('ギフト') || description.include?('ギフト')
      'gift'
    else
      'tea'
    end
  end
end
