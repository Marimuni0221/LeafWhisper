class UserDecorator < Draper::Decorator
  delegate_all

  def display_name
    object.name.present? ? object.name : '匿名ユーザー'
  end

end
