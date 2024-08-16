class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reviewable, only: [:new, :create]

  def new
    Rails.logger.debug "ReviewsController#new - @reviewable: #{@reviewable.inspect}"

    @review = @reviewable.reviews.new
    respond_to do |format|
      format.html { render partial: 'reviews/form', layout: false, locals: { reviewable: @reviewable, review: @review } } 
      format.turbo_stream # Turbo Stream形式でのレンダリング
    end
  end

  def create
    Rails.logger.debug "ReviewsController#create - @reviewable: #{@reviewable.inspect}, review_params: #{review_params.inspect}"

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
    Rails.logger.debug "ReviewsController#set_reviewable - Params: #{params.inspect}"

    if params[:product_item_url]
      @reviewable = Product.find_by(url_hash: params[:product_item_url])
      Rails.logger.debug "Found Product: #{@reviewable.inspect}"
      
      unless @reviewable
        redirect_to root_path, alert: '商品が見つかりませんでした。'
      end
    elsif params[:cafe_place_id]
      @reviewable = Cafe.find_or_create_cafe(params[:cafe_place_id])
      Rails.logger.debug "Found or Created Cafe: #{@reviewable.inspect}"
      
      unless @reviewable
        redirect_to root_path, alert: 'カフェが見つかりませんでした。'
      end
    else
      Rails.logger.error "レビュー対象が不明です。"
      redirect_to root_path, alert: 'レビュー対象が不明です。'
    end
  end
  
  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end

