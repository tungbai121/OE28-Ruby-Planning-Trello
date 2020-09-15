class Label < ApplicationRecord
  has_many :tag_labels, class_name: TagLabel.name,
    foreign_key: :label_id,
    dependent: :destroy
  has_many :join_tags, through: :tag_labels, source: :tag
end
