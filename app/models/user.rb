class User < ApplicationRecord
  USER_PARAMS = %i(name avatar).freeze

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i(google_oauth2)

  has_many :user_boards, class_name: UserBoard.name,
    foreign_key: :user_id, dependent: :destroy
  has_many :boards, through: :user_boards, source: :board
  has_many :card_users, class_name: CardUser.name,
    foreign_key: :user_id,
    dependent: :destroy
  has_many :cards, through: :card_users, source: :card
  has_many :comments, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :annoucements, dependent: :destroy

  mount_uploader :avatar, AvatarUploader

  delegate :url, :size, :filename, to: :avatar

  validates :name, presence: true,
    length: {maximum: Settings.user.name.length}

  scope :exclude_ids, ->(ids){where.not(id: ids)}

  def update_without_password params, *options
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete :password
      params.delete :password_confirmation
    end
    result = update params, *options
    clean_up_passwords
    result
  end

  def is_leader? board
    user_boards.user_role(id, board.id).leader?
  end

  class << self
    def from_omniauth auth
      where(email: auth.info.email).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.name = auth.info.name
        user.skip_confirmation!
      end
    end
  end
end
