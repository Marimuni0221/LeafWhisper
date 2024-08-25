module ApplicationHelper
  def turbo_stream_flash
    turbo_stream.update "flash", partial: "shared/flash_message"
  end

  def favorites_page?
    controller_name == 'users' && action_name == 'favorites'
  end
end
