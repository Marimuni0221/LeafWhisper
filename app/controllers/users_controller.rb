class UsersController < ApplicationController
  before_action :authenticate_user!

  def reviews
    @user = User.find(params[:id])
    @reviews = @user.reviews.includes(:reviewable)
  end

end
