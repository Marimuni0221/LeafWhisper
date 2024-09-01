# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def top
    @q = Product.ransack(params[:q] || {})
  end

  def terms; end

  def privacy; end
end
