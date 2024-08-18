class ContactMailer < ApplicationMailer
  def send_contact_email(contact_name, contact_email, contact_message)
    @contact_name = contact_name
    @contact_email = contact_email
    @contact_message = contact_message

    mail(
      to: ENV['MAIL_ADDRESS'],
      subject: 'お問い合わせがありました'
    )
  end
end
