class StaticPagesController < ApplicationController
  def top
    @q = Product.ransack(params[:q] || {})
  end
end
