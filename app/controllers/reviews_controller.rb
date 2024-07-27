class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reviewable, only: [:new, :create]

  def new
    @review = @reviewable.reviews.new
    respond_to do |format|
      format.html { render partial: 'reviews/form', layout: false, locals: { reviewable: @reviewable, review: @review } } 
      format.turbo_stream # Turbo Stream形式でのレンダリング
    end
  end

  def create
    @review = @reviewable.reviews.new(review_params)
    @review.user = current_user
    if @review.save
      respond_to do |format|
        format.html { redirect_to search_products_path, notice: 'レビューが投稿されました。' }
        format.turbo_stream
      end
    else
      render :new, layout: false
    end 
  end

  private

  def set_reviewable
    Rails.logger.debug "params[:product_item_url]: #{params[:product_item_url]}"
    @reviewable = Product.find_by(url_hash: params[:product_item_url])
    unless @reviewable
      Rails.logger.debug "Product not found for item_url: #{params[:product_item_url]}"
      redirect_to root_path, alert: '商品が見つかりませんでした。'
    end
  end
  
  def review_params
    params.require(:review).permit(:rating, :comment)
  end

end
