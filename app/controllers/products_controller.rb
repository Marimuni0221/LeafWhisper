class ProductsController < ApplicationController
  def search
    @q = Product.ransack(params[:q] || {})
    @products = @products.price_range(params[:price_range]) if params[:price_range].present?
    @products = ProductDecorator.decorate_collection(@q.result, price_range: params.dig(:q, :price_range))
  end
end
