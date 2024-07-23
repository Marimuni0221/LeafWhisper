class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id])
  end

  def search
    @q = Product.ransack(params[:q] || {})
    @products = @q.result

    # 価格帯フィルターを適用
    @products = @products.price_range(params[:price_range]) if params[:price_range].present?
    
    # ページネーションを適用
    @products = @products.page(params[:page])

    # 検索結果にデコレーターを適用
    @products = PaginatingDecorator.decorate(@products)


    # アクションのレスポンスをリクエストの形式に基づいて分岐させる設定
    respond_to do |format|
      format.turbo_stream
      format.html { render :search }
    end
  end
end
