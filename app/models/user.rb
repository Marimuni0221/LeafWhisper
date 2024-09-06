# frozen_string_literal: true

class User < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  mount_uploader :avatar, AvatarUploader

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { password_required? }
  validates :password_confirmation, presence: true, if: -> { password_required? }

  def self.from_omniauth(auth)
    existing_user = find_existing_user(auth[:info][:email])

    existing_user || create_or_update_user_from_auth(auth)
  end

  def favorite(favoritable)
    favorites.create(favoritable:)
  end

  def unfavorite(favoritable)
    favorites.find_by(favoritable:)&.destroy
  end

  def favorited?(favoritable)
    favorites.exists?(favoritable:)
  end

  def self.find_existing_user(email)
    User.find_by('lower(email) = ?', email.downcase)
  end

  def self.create_or_update_user_from_auth(auth)
    user = where(provider: auth[:provider], uid: auth[:uid]).first_or_initialize
    user.email = auth[:info][:email]
    user.password = Devise.friendly_token[0, 20]
    user.name = auth[:info][:name] if user.respond_to?(:name)
    user if user.save
  end

  private

  # パスワードの検証をスキップするためのメソッド
  def password_required?
    provider.blank? && super
  end
end
