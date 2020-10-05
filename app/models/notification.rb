class Notification < ApplicationRecord
  belongs_to :board
  belongs_to :user

  validates :content, presence: true,
    length: {maximum: Settings.tag.name.length}

  scope :order_created, ->{order created_at: :desc}
end
