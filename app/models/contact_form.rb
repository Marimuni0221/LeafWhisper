class ContactForm
  include ActiveModel::Model

  # フォームのフィールドを定義
  attr_accessor :name, :email, :message

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :message, presence: true
end
