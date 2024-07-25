class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reviewable, only: [:new, :create]

  def new
    @review = @reviewable.reviews.new
  end

  def create
    @review = @reviewable.reviews.new(review_params)
    @review.user = current_user
    if @review.save
      respond_to do |format|
        format.html { redirect_to @reviewable, notice: 'レビューが投稿されました。' }
        format.turbo_stream
      end
    else
      render :new
    end 
  end

  private
  
  def set_reviewable
    @reviewable = find_reviewable
  end

  def set_reviewable
    @reviewable = Product.find_by(url_hash: params[:item_url])
    unless @reviewable
      redirect_to root_path, alert: '商品が見つかりませんでした。'
    end
  end
  
  def review_params
    params.require(:review).permit(:rating, :comment)
  end

end
