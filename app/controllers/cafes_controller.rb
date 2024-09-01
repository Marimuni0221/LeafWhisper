# frozen_string_literal: true

class CafesController < ApplicationController
  include ApplicationHelper

  def search; end

  def save
    cafe = Cafe.find_or_initialize_by(place_id: params[:place_id])
    cafe.name = params[:name]
    cafe.address = params[:address]
    cafe.phone_number = params[:phone_number] # 電話番号
    cafe.cafe_url = params[:cafe_url] # カフェのURL
    cafe.cafe_image_url = params[:cafe_image_url] # カフェの画像URL
    if cafe.save
      render json: { status: 'success', cafe_id: cafe.id }
    else
      render json: { status: 'error', errors: cafe.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def favorite_button
    @cafe = Cafe.find_by(place_id: params[:id])
    Rails.logger.debug { "Found Cafe: #{@cafe.inspect}" }
    unless @cafe
      render plain: 'Cafe not found', status: :not_found
      return
    end

    # お気に入りボタンのHTMLを生成
    favorite_button_html = render_to_string(partial: 'favorites/favorite_buttons', locals: { favoritable: @cafe })

    # シェアURLを生成
    share_url = share_on_x_url(@cafe)

    # favorite_button_htmlとshare_urlをJSON形式で返す
    render json: { favorite_button_html:, share_url: }
  end
end
