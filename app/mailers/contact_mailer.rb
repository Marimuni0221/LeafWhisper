# frozen_string_literal: true

class ContactMailer < ApplicationMailer
  def send_contact_email(contact_name, contact_email, contact_message)
    @contact_name = contact_name
    @contact_email = contact_email
    @contact_message = contact_message

    mail(
      to: ENV.fetch('MAIL_ADDRESS', nil),
      subject: I18n.t('contact_mailer.send_contact_email.subject')
    )
  end
end
