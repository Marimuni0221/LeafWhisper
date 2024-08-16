class Cafe < ApplicationRecord
  has_many :reviews, as: :reviewable, dependent: :destroy

  def self.find_or_create_cafe(place_id)
    cafe = Cafe.find_by(place_id: place_id)
    unless cafe
      # Google Maps APIからカフェ情報を取得し、データベースに保存
      cafe_data = fetch_cafe_data_from_google(place_id)  # ここでGoogle Maps APIを呼び出す
      cafe = Cafe.create(
        place_id: place_id,
        name: cafe_data[:name],
        latitude: cafe_data[:latitude],
        longitude: cafe_data[:longitude],
        address: cafe_data[:address]
      )
    end
    cafe
  end

  private

  def self.fetch_cafe_data_from_google(place_id)
    # Google Maps APIを使ってデータを取得するロジック
    # 例えば、HTTPartyやFaradayなどのHTTPクライアントを使ってAPIにリクエストを送る
    response = GoogleMapsService.get_place_details(place_id)
    {
      name: response['name'],
      latitude: response['geometry']['location']['lat'],
      longitude: response['geometry']['location']['lng'],
      address: response['formatted_address']
    }
  end
end
