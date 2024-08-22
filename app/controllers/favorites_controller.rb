class FavoritesController < ApplicationController
  before_action :set_favoritable

  def create
    current_user.favorite(@favoritable)
    flash.now[notice] = 'お気に入りに追加しました' 
  end

  def destroy
    current_user.unfavorite(@favoritable)
    flash.now[notice] = 'お気に入りから削除しました' 
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
                  
    # デバッグログを追加
    Rails.logger.debug "Favoritable: #{@favoritable.inspect}"
  
    # 万が一@favoritableがnilだった場合の処理
    unless @favoritable
      redirect_to root_path, alert: 'お気に入り対象が見つかりませんでした。'
    end
  end  
end
