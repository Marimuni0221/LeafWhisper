# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reviewable, only: %i[new create]
  before_action :set_review, only: %i[destroy]

  def new
    @review = @reviewable.reviews.new
    respond_to do |format|
      format.html do
        render partial: 'reviews/form', layout: false, locals: { reviewable: @reviewable, review: @review }
      end
      format.turbo_stream
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

  def destroy
    if @review.user == current_user
      @review.destroy!
      redirect_to review_path(@review.reviewable), notice: 'レビューが削除されました。', status: :see_other
    else
      redirect_to product_path(@review.reviewable), alert: 'このレビューを削除する権限がありません。', status: :see_other
    end
  end

  private

  def set_reviewable
    @reviewable = Product.find_by(url_hash: params[:product_item_url])
    return if @reviewable

    redirect_to root_path, alert: '商品が見つかりませんでした。'
  end

  def set_review
    @review = Review.find(params[:id])
    return if @review

    redirect_to root_path, alert: 'レビューが見つかりませんでした。'
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
