class ContactsController < ApplicationController
  def new
    @contact = {} # 空のハッシュを使ってビューに渡す
  end

  def create
    @contact = params[:contact]

    if contact_params_invalid?
      handle_validation_errors
      return
    end

    send_contact_email
    redirect_to new_contact_path, notice: I18n.t('contacts.notices.sent')
  end

  private

  def contact_params_invalid?
    contact_name.blank? || contact_email.blank? || contact_message.blank?
  end

  def handle_validation_errors
    flash.now[:alert] = []
    add_name_error if contact_name.blank?
    add_email_error if contact_email.blank?
    add_message_error if contact_message.blank?

    render :new, status: :unprocessable_entity
  end

  def add_name_error
    flash.now[:alert] << I18n.t('contacts.errors.name_blank')
  end

  def add_email_error
    flash.now[:alert] << I18n.t('contacts.errors.email_blank')
  end

  def add_message_error
    flash.now[:alert] << I18n.t('contacts.errors.message_blank')
  end

  def send_contact_email
    ContactMailer.send_contact_email(contact_name, contact_email, contact_message).deliver_now
  end

  def contact_name
    params[:contact][:name]
  end

  def contact_email
    params[:contact][:email]
  end

  def contact_message
    params[:contact][:message]
  end
end
