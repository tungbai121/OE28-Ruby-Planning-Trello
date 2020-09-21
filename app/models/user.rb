class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.user.email.regex
  USER_PARAMS = %i(name email password password_confirmation).freeze

  has_many :user_boards, class_name: UserBoard.name,
    foreign_key: :user_id,
    dependent: :destroy
  has_many :join_boards, through: :user_boards, source: :board
  has_many :tag_users, class_name: TagUser.name,
    foreign_key: :user_id,
    dependent: :destroy
  has_many :join_tags, through: :tag_users, source: :tag
  has_many :comments, dependent: :destroy

  validates :email, presence: true,
    length: {maximum: Settings.user.email.length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: true
  validates :name, presence: true,
    length: {maximum: Settings.user.name.length}
  validates :password, presence: true,
    length: {minimum: Settings.user.password.length}

  before_save :downcase_email

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
