class ProductsController < ApplicationController
  def search
    @q = Product.ransack(params[:q] || {})
    @products = @q.result

    # 価格帯フィルターを適用
    @products = @products.price_range(params[:price_range]) if params[:price_range].present?
    
    # ページネーションを適用
    @products = @products.page(params[:page])

    # 検索結果にデコレーターを適用
    @products = ProductDecorator.decorate_collection(@q.result, price_range: params.dig(:q, :price_range))

    # アクションのレスポンスをリクエストの形式に基づいて分岐させる設定
    respond_to do |format|
      format.turbo_stream
      format.html { render :search }
    end
  end
end
