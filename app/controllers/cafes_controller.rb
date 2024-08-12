class CafesController < ApplicationController
  def search
    # ユーザーの検索クエリを取得
    query = params[:query]

    # カフェの検索ロジック（例: データベース検索やAPI呼び出し）
    @cafes = Cafe.where('name LIKE ?', "%#{query}%")

    # 例: Google Maps APIを使用して検索結果を地図にマッピング
    respond_to do |format|
      format.html # search.html.erb ビューを表示
      format.json { render json: @cafes } # JSON形式で検索結果を返す
    end
  end
end
