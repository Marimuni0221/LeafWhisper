# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def reviews
    @user = User.find(params[:id])
    @reviews = @user.reviews.includes(:reviewable)
  end

  def favorites
    @user = User.find(params[:id])
    @favorites = @user.favorites.includes(:favoritable)
  end
end
