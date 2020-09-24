class Tag < ApplicationRecord
  TAG_PARAMS = %i(name description).freeze

  has_many :tag_labels, class_name: TagLabel.name,
    foreign_key: :tag_id, dependent: :destroy
  has_many :labels, through: :tag_labels, source: :label
  has_many :tag_users, class_name: TagUser.name,
    foreign_key: :tag_id, dependent: :destroy
  has_many :users, through: :tag_users, source: :user
  has_many :comments, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :checklists, dependent: :destroy
  belongs_to :list

  validates :name, presence: true,
    length: {maximum: Settings.tag.name.length}
  validates :description, length: {maximum: Settings.tag.description.length}

  scope :opened, ->{where closed: false}
  scope :closed, ->{where closed: true}
  scope :last_position, ->{maximum :position}
end
