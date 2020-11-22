class Label < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(content).freeze

  has_many :card_labels, class_name: CardLabel.name,
    foreign_key: :label_id,
    dependent: :destroy
  has_many :join_cards, through: :card_labels, source: :card
  belongs_to :board

  validates :content, presence: true,
    length: {maximum: Settings.validate.max_label_content}

  scope :exclude_ids, ->(ids){where.not id: ids}
end
