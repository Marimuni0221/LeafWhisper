module ApplicationHelper
  def turbo_stream_flash
    turbo_stream.update "flash", partial: "shared/flash_message"
  end

  def favorites_page?
    request.referer == favorites_url
  end
end
