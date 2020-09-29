class Board < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(name description status).freeze

  has_many :user_boards, class_name: UserBoard.name,
    foreign_key: :board_id,
    dependent: :destroy
  has_many :add_users, through: :user_boards, source: :user
  has_many :lists, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :labels, dependent: :destroy

  validates :name, presence: true,
    length: {maximum: Settings.validate.max_board_name}

  validates :description, presence: true,
    length: {maximum: Settings.validate.max_board_description}

  scope :favorite, (lambda do |user_id|
    includes(:user_boards)
    .where(user_boards: {user_id: user_id,
                         starred: true})
  end)

  scope :nonfavorite, (lambda do |user_id|
    includes(:user_boards)
    .where(user_boards: {user_id: user_id,
                         starred: nil})
  end)

  scope :opened, ->{where closed: false}
end
