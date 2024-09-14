# frozen_string_literal: true

class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.valid?
      send_contact_email
      redirect_to new_contact_path, notice: I18n.t('contacts.notices.sent')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end

  def send_contact_email
    ContactMailer.send_contact_email(
      @contact.name,
      @contact.email,
      @contact.message
    ).deliver_now
  end
end
