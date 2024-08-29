class ProductsController < ApplicationController 
  require 'digest'
  def search
    # ここでセッションの保存を無効にする
    request.session_options[:store] = false

    @q = Product.ransack(params[:q] || {})
    keyword = params[:q].present? ? params[:q][:name_or_description_cont] : '抹茶'
    category = params.dig(:q, :category_eq).to_sym if params.dig(:q, :category_eq).present?
    page = params[:page]

    @products = fetch_products(keyword, page)

    # カテゴリフィルターを適用
    if category.present?
      @products = @products.select { |product| product[:category].to_sym == category }
    end

    # 価格帯フィルターを適用
    if params[:price_range].present?
      @products = apply_price_range(@products, params[:price_range])
    end
    
    # 商品リストをセッションに保存
    session[:products] = @products

    # ページネーションを適用
    @products = Kaminari.paginate_array(@products).page(params[:page])

    # 検索結果にデコレーターを適用
    @products = PaginatingDecorator.decorate(@products)

    @products = ProductDecorator.decorate(@products)

    # アクションのレスポンスをリクエストの形式に基づいて分岐させる設定
    respond_to do |format|
      format.turbo_stream
      format.html { render :search }
    end
  end

  private
  
  def fetch_products(keyword, page)
    # キーワードが無効な場合の対応
    if keyword.blank?
      keyword = '抹茶'
    elsif !keyword.include?('抹茶')
      keyword = "#{keyword} 抹茶"
    end
    
    items = []
    (1..5).each do |i| # 最大5ページまで取得する例
      result = RakutenWebService::Ichiba::Item.search(keyword: keyword, page: i)
      break if result === 0
      result.each do |item|
        items << item
      end
    end

    items.map do |item|
      url_hash = Digest::SHA256.hexdigest(item['itemUrl'])
      product = Product.find_or_initialize_by(url_hash: url_hash)

      product.assign_attributes(
        name: item['itemName'],
        description: item['itemCaption'],
        price: item['itemPrice'],
        item_url: item['itemUrl'],
        item_image_url: item['mediumImageUrls'].first,
        category: determine_category(item['itemName'], item['itemCaption']),
        url_hash: url_hash
      )
      product
    end
      
  end

  def apply_price_range(products, range)
    case range
    when 'under_500'
      products.select { |product| product[:price] < 500 }
    when '500_to_1000'
      products.select { |product| product[:price] >= 500 && product[:price] <= 1000 }
    when '1000_to_2000'
      products.select { |product| product[:price] >= 1000 && product[:price] <= 2000 }
    when '2000_to_3000'
      products.select { |product| product[:price] >= 2000 && product[:price] <= 3000 }
    when 'above_3000'
      products.select { |product| product[:price] > 3000 }
    else
      products
    end
  end

  def determine_category(name, description)
    if name.include?('スイーツ') || description.include?('スイーツ')
      'sweets'
    elsif name.include?('ギフト') || description.include?('ギフト')
      'gift'
    elsif name.include?('コスメ') || description.include?('コスメ')
      'cosmetics'
    else
      'tea'
    end
  end
end