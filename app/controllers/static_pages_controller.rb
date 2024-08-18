class StaticPagesController < ApplicationController
  def top
    @q = Product.ransack(params[:q] || {})
  end

  def terms;end  
end
