module ReviewsHelper
  def review_form_url(reviewable)
    if reviewable.is_a?(Product)
      product_reviews_path(reviewable.url_hash)
    elsif reviewable.is_a?(Cafe)
      cafe_reviews_path(reviewable.place_id)
    else
      "#"
    end
  end
end
