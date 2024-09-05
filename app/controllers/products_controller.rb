# frozen_string_literal: true

class ProductsController < ApplicationController
  require 'digest'

  def search
    # セッション保存を無効化
    request.session_options[:store] = false

    # 検索パラメータの抽出
    @q = Product.ransack(params[:q] || {})
    keyword = extract_keyword(params[:q])
    category = extract_category(params[:q])
    page = params[:page]

    # 商品を取得
    @products = fetch_products(keyword, page)

    # フィルタリングを適用
    apply_filters(category, params[:price_range])

    # セッションに商品を保存
    session[:products] = @products

    # 商品をページネーション
    @products = paginate_products(@products)

    # レスポンスの形式に応じた処理
    respond_with_products
  end

  private

  # 検索キーワードの抽出
  def extract_keyword(query_params)
    query_params.present? ? query_params[:name_or_description_cont] : '抹茶'
  end

  # カテゴリの抽出
  def extract_category(query_params)
    query_params[:category_eq].to_sym if query_params.present? && query_params[:category_eq].present?
  end

  # フィルタの適用
  def apply_filters(category, price_range)
    filter_by_category(category) if category.present?
    filter_by_price_range(price_range) if price_range.present?
  end

  # カテゴリでフィルタリング
  def filter_by_category(category)
    @products = @products.select { |product| product[:category].to_sym == category }
  end

  # 価格帯でフィルタリング
  def filter_by_price_range(price_range)
    @products = apply_price_range(@products, price_range)
  end

  # 商品のページネーション
  def paginate_products(products)
    Kaminari.paginate_array(products).page(params[:page])
  end

  # 商品のレスポンスを処理
  def respond_with_products
    @products = PaginatingDecorator.decorate(@products)
    @products = ProductDecorator.decorate(@products)

    respond_to do |format|
      format.turbo_stream
      format.html { render :search }
    end
  end

  # 商品を楽天APIから取得
  def fetch_products(keyword, _page)
    keyword = adjust_keyword(keyword)
    items = fetch_items_from_rakuten(keyword)
    items.map { |item| build_product(item) }
  end

  # キーワードの調整
  def adjust_keyword(keyword)
    return I18n.t('products.default_keyword') if keyword.blank?

    keyword.exclude?(I18n.t('products.default_keyword')) ? "#{keyword} #{I18n.t('products.default_keyword')}" : keyword
  end

  # 楽天APIからアイテムを取得
  def fetch_items_from_rakuten(keyword)
    items = []
    (1..5).each do |i|
      result = RakutenWebService::Ichiba::Item.search(keyword:, page: i)
      break if result.count.zero?

      items.concat(result)
    end
    items
  end

  # 商品オブジェクトの生成
  def build_product(item)
    url_hash = Digest::SHA256.hexdigest(item['itemUrl'])
    product = Product.find_or_initialize_by(url_hash:)

    product.assign_attributes(
      name: item['itemName'],
      description: item['itemCaption'],
      price: item['itemPrice'],
      item_url: item['itemUrl'],
      item_image_url: item['mediumImageUrls'].first,
      category: determine_category(item['itemName'], item['itemCaption']),
      url_hash:
    )
    product
  end

  # 商品のカテゴリを決定
  def determine_category(name, description)
    if name.include?('スイーツ') || description.include?('スイーツ')
      'sweets'
    elsif name.include?('ギフト') || description.include?('ギフト')
      'gift'
    else
      'tea'
    end
  end

  # 価格範囲でフィルタリング
  def apply_price_range(products, range)
    products.select { |product| in_price_range?(product[:price], range) }
  end

  # 価格範囲の判定
  def in_price_range?(price, range)
    case range
    when 'under_500'
      price < 500
    when '500_to_1000'
      price >= 500 && price <= 1000
    when '1000_to_2000'
      price >= 1000 && price <= 2000
    when '2000_to_3000'
      price >= 2000 && price <= 3000
    when 'above_3000'
      price > 3000
    else
      true
    end
  end
end
