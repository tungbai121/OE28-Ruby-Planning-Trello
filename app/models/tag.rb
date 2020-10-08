class Tag < ApplicationRecord
  TAG_PARAMS = %i(name description).freeze

  attr_accessor :user_id

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

  after_create :create_notification
  before_update ->{update_notification("name", name_change[1])},
                if: :will_save_change_to_name?

  private

  def create_notification
    notification = list.board.notifications.build user_id: user_id
    notification.content = [
      I18n.t(".tags.create.noti_create"),
      I18n.t(".tags.create.tag"),
      name
    ].join(" ")
    notification.save
  end

  def update_notification attribute, new_value
    notification = list.board.notifications.build user_id: user_id
    notification.content = [
      I18n.t(".tags.create.noti_update"),
      I18n.t(".tags.create.tag"),
      attribute,
      I18n.t(".tags.create.to"),
      new_value
    ].join(" ")
    notification.save
  end
end
