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
  has_many :notifications, dependent: :destroy

  validates :email, presence: true,
    length: {maximum: Settings.user.email.length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: true
  validates :name, presence: true,
    length: {maximum: Settings.user.name.length}
  validates :password, presence: true,
    length: {minimum: Settings.user.password.length},
    allow_nil: true

  scope :exclude_ids, ->(ids){where.not(id: ids)}

  before_save :downcase_email

  has_secure_password

  def join_board board, type
    check = type.to_i.eql? Settings.data.confirm
    join_boards << board
    board.user_boards.first.update_attribute(:starred, true) if check
    board.user_boards.first.update_attribute(:role_id, :leader)
  end

  def send_email_join board_id
    UserMailer.user_invitation(self, board_id).deliver_now
  end

  def is_leader? board
    user_boards.user_role(id, board.id).leader?
  end

  private

  def downcase_email
    email.downcase!
  end
end
