class Label < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(content).freeze

  has_many :tag_labels, class_name: TagLabel.name,
    foreign_key: :label_id,
    dependent: :destroy
  has_many :join_tags, through: :tag_labels, source: :tag

  validates :content, presence: true,
    length: {maximum: Settings.validate.max_label_content}

  scope :exclude_ids, ->(ids){where.not id: ids}
end
