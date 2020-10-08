class Board < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(name description status closed).freeze

  attr_accessor :user_id

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
  scope :closed, ->{where closed: true}
  scope :order_created, ->{order created_at: :desc}

  before_update ->{update_notification("name", name_change[1])},
                if: :will_save_change_to_name?
  before_update ->{update_notification("description", description_change[1])},
                if: :will_save_change_to_description?

  private

  def update_notification attribute, new_value
    notification = notifications.build user_id: user_id
    notification.content = [
      I18n.t(".boards.create.noti_update"),
      I18n.t(".lists.create.board"),
      attribute,
      I18n.t(".boards.create.to"),
      new_value
    ]
    notification.save
  end
end
