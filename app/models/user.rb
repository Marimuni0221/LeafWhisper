class User < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  mount_uploader :avatar, AvatarUploader

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { password_required? }
  validates :password_confirmation, presence: true, if: -> { password_required? }

  def self.from_omniauth(auth)
    # メールアドレスで既存ユーザーを検索
    existing_user = User.find_by(email: auth[:info][:email])
    
    if existing_user
      # 既存ユーザーが見つかった場合、そのユーザーを返す
      existing_user
    else
      # providerとuidで既存の認証情報を持つユーザーを検索または新規作成
      user = where(provider: auth[:provider], uid: auth[:uid]).first_or_initialize
      user.email = auth[:info][:email]
      user.password = Devise.friendly_token[0,20]
  
      # 必要に応じて他のフィールドも設定
      user.name = auth[:info][:name] if user.respond_to?(:name)
  
      if user.save
        user
      else
        nil
      end
    end
  end

  def favorite(favoritable)
    favorites.create(favoritable: favoritable)
  end

  def unfavorite(favoritable)
    favorites.find_by(favoritable: favoritable)&.destroy
  end

  def favorited?(favoritable)
    favorites.exists?(favoritable: favoritable)
  end
  
  private

  # パスワードの検証をスキップするためのメソッド
  def password_required?
    provider.blank? && super
  end
end
