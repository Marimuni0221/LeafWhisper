class CafesController < ApplicationController
  def search;end

  def save
    cafe = Cafe.find_or_initialize_by(place_id: params[:place_id])
    cafe.name = params[:name]
    cafe.address = params[:address]
    if cafe.save
      render json: { status: 'success', cafe_id: cafe.id }
    else
      render json: { status: 'error', errors: cafe.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def favorite_button
    @cafe = Cafe.find_by(place_id: params[:id])
    Rails.logger.debug "Found Cafe: #{@cafe.inspect}"
    unless @cafe
      render plain: "Cafe not found", status: :not_found
      return
    end
    render partial: 'favorites/favorite_buttons', locals: { favoritable: @cafe }
  end
  
end
