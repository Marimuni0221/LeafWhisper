# frozen_string_literal: true

# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  def search
    @products = ProductSearchService.new(params).call
    session[:products] = @products
    @products = paginate_products(@products)
    respond_with_products
  end

  private

  def paginate_products(products)
    Kaminari.paginate_array(products).page(params[:page])
  end

  def respond_with_products
    @products = PaginatingDecorator.decorate(@products)
    @products = ProductDecorator.decorate(@products)

    respond_to do |format|
      format.turbo_stream
      format.html { render :search }
    end
  end
end
