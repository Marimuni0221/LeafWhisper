# frozen_string_literal: true

class ContactsController < ApplicationController
  def new; end

  def create
    contact_name = params[:name]
    contact_email = params[:email]
    contact_message = params[:message]

    # バリデーションの実施
    if contact_name.blank? || contact_email.blank? || contact_message.blank?
      flash.now[:alert] = []
      flash.now[:alert] << I18n.t('contacts.errors.name_blank') if contact_name.blank?
      flash.now[:alert] << I18n.t('contacts.errors.email_blank') if contact_email.blank?
      flash.now[:alert] << I18n.t('contacts.errors.message_blank') if contact_message.blank?

      render :new, status: :unprocessable_entity
      return
    end

    # メールを送信
    ContactMailer.send_contact_email(contact_name, contact_email, contact_message).deliver_now

    redirect_to new_contact_path, notice: I18n.t('contacts.notices.sent')
  end
end
