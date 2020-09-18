class Tag < ApplicationRecord
  has_many :tag_labels, class_name: TagLabel.name,
    foreign_key: :tag_id,
    dependent: :destroy
  has_many :add_labels, through: :tag_labels, source: :label
  has_many :tag_users, class_name: TagUser.name,
    foreign_key: :tag_id,
    dependent: :destroy
  has_many :add_users, through: :tag_users, source: :user
  has_many :comments, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :checklists, dependent: :destroy
  belongs_to :list
end
