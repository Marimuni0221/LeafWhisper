# frozen_string_literal: true

class ContactMailer < ApplicationMailer
  def send_contact_email(contact_name, contact_email, contact_message)
    @contact_name = contact_name
    @contact_email = contact_email
    @contact_message = contact_message

    mail(
      to: ENV.fetch('MAIL_ADDRESS', nil),
      subject: 'お問い合わせがありました'
    )
  end
end
