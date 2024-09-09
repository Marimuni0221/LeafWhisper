# frozen_string_literal: true

# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  def search
    # サービスクラスを呼び出して検索結果を取得
    @products = ProductSearchService.new(params).call

    # セッションに商品を保存
    session[:products] = @products

    # 商品をページネーション
    @products = paginate_products(@products)

    # レスポンスの形式に応じた処理
    respond_with_products
  end

  private

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
end
