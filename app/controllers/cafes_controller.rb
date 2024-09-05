# frozen_string_literal: true

class CafesController < ApplicationController
  include ApplicationHelper

  def search; end

  def save
    cafe = find_or_initialize_cafe
    update_cafe_attributes(cafe)

    if cafe.save
      render_success(cafe)
    else
      render_error(cafe)
    end
  end

  def favorite_button
    @cafe = Cafe.find_by(place_id: params[:id])
    unless @cafe
      render plain: 'Cafe not found', status: :not_found
      return
    end

    favorite_button_html = render_to_string(partial: 'favorites/favorite_buttons', locals: { favoritable: @cafe })
    share_url = share_on_x_url(@cafe)

    render json: { favorite_button_html:, share_url: }
  end

  private

  def find_or_initialize_cafe
    Cafe.find_or_initialize_by(place_id: params[:place_id])
  end

  def update_cafe_attributes(cafe)
    cafe.name = params[:name]
    cafe.address = params[:address]
    cafe.phone_number = params[:phone_number]
    cafe.cafe_url = params[:cafe_url]
    cafe.cafe_image_url = params[:cafe_image_url]
  end

  def render_success(cafe)
    render json: { status: 'success', cafe_id: cafe.id }
  end

  def render_error(cafe)
    render json: { status: 'error', errors: cafe.errors.full_messages }, status: :unprocessable_entity
  end
end
