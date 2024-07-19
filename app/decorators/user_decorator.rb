class UserDecorator < Draper::Decorator
  delegate_all

  def display_name
    object.name.present? ? object.name : '匿名ユーザー'
  end
  

  def display_avatar_url
    object.avatar.present? ? object.avatar.url : ActionController::Base.helpers.asset_path('default_avatar.png')
  end
end
