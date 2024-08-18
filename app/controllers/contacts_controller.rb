class ContactsController < ApplicationController
  def new;end

  def create
    contact_name = params[:name]
    contact_email = params[:email]
    contact_message = params[:message]

    # メールを送信
    ContactMailer.send_contact_email(contact_name, contact_email, contact_message).deliver_now

    redirect_to new_contact_path, notice: 'お問い合わせが送信されました。'
  end
end
