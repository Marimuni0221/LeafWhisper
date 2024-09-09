# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :set_favoritable, except: [:index]
  before_action :authenticate_user!

  def index
    @favorites = current_user.favorites.includes(:favoritable)
  end

  def create
    current_user.favorite(@favoritable)
    flash.now[:notice] = I18n.t('favorites.added')
  end

  def destroy
    @favorite = current_user.favorites.find(params[:id])
    @favoritable = @favorite.favoritable
    current_user.unfavorite(@favoritable)
    flash.now[:notice] = I18n.t('favorites.removed')
  end

  private

  def set_favoritable
    @favoritable = find_favoritable
    return if @favoritable

    redirect_to root_path, alert: I18n.t('favorites.not_found')
  end

  def find_favoritable
    if params[:product_item_url]
      Product.find_by(url_hash: params[:product_item_url])
    elsif params[:cafe_id]
      Cafe.find(params[:cafe_id])
    elsif params[:id]
      favorite = Favorite.find(params[:id])
      favorite.favoritable
    end
  end
end
