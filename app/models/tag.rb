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
  validates_datetime :deadline, presence: true, allow_nil: true

  scope :opened, ->{where closed: false}
  scope :closed, ->{where closed: true}
  scope :last_position, ->{maximum :position}
  scope :order_by_updated_at, ->{order updated_at: :desc}
  scope :of_user, (lambda do |user_id|
    joins(list: {board: :user_boards})
      .where(user_boards: {user_id: user_id})
  end)

  after_create :create_notification
  after_update :deprecation_after_update

  private

  def create_notification
    notification = list.board.notifications.build user_id: user_id
    notification.content = I18n.t(".create", name: name)
    notification.save
  end

  def deprecation_after_update
    if saved_change_to_name? && saved_change_to_description?
      update_notification "description", saved_changes[:description]
      update_notification "name", saved_changes[:name]
    elsif saved_change_to_name?
      update_notification "name", saved_changes[:name]
    elsif saved_change_to_description?
      update_notification "description", saved_changes[:description]
    end
  end

  def update_notification attribute, values
    notification = list.board.notifications.build user_id: user_id
    notification.content = I18n.t(".update", attribute: attribute,
                                             tag_name: name_before_last_save,
                                             value: values[1])
    notification.save
  end
end
