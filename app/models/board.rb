class Board < ApplicationRecord
  has_many :user_boards, class_name: UserBoard.name,
    foreign_key: :board_id,
    dependent: :destroy
  has_many :add_users, through: :user_boards, source: :user
  has_many :lists, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :labels, dependent: :destroy

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
end
