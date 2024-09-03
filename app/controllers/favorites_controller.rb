# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_favoritable, except: [:index]

  def index
    @favorites = current_user.favorites.includes(:favoritable)
  end

  def create
    if @favoritable
      current_user.favorite(@favoritable)
      flash.now[:notice] = I18n.t('favorites.added')
    else
      flash[:alert] = I18n.t('favorites.not_found')
    end
    redirect_to request.referer || root_path
  end

  def destroy
    @favorite = current_user.favorites.find(params[:id])
    if @favorite
      @favoritable = @favorite.favoritable
      current_user.unfavorite(@favoritable)
      flash[:notice] = I18n.t('favorites.removed')
    else
      flash[:alert] = I18n.t('favorites.not_found')
    end
    redirect_to request.referer || root_path
  end

  private

  def set_favoritable
    if params[:product_item_url]
      @favoritable = Product.find_by(url_hash: params[:product_item_url])
    elsif params[:cafe_id]
      @favoritable = Cafe.find(params[:cafe_id])
    elsif params[:id] # 削除アクション時に使う場合
      favorite = Favorite.find(params[:id])
      @favoritable = favorite.favoritable
    end

    # 万が一@favoritableがnilだった場合の処理
    return if @favoritable

    redirect_to root_path, alert: I18n.t('favorites.not_found')
  end
end
