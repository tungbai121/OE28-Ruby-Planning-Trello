class Activity < ApplicationRecord
  belongs_to :board
  belongs_to :user

  validates :action, presence: true,
    length: {maximum: Settings.card.name.length}

  scope :order_by_created_at, ->{order created_at: :desc}
end
