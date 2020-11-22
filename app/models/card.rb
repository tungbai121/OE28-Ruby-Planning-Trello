class Card < ApplicationRecord
  TAG_PARAMS = %i(name description).freeze

  attr_accessor :user_id

  has_many :card_labels, class_name: CardLabel.name,
    foreign_key: :card_id, dependent: :destroy
  has_many :labels, through: :card_labels, source: :label
  has_many :card_users, class_name: CardUser.name,
    foreign_key: :card_id, dependent: :destroy
  has_many :users, through: :card_users, source: :user
  has_many :comments, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :checklists, dependent: :destroy
  has_many :annoucements, as: :annoucementable, dependent: :destroy
  belongs_to :list

  validates :name, presence: true,
    length: {maximum: Settings.card.name.length}
  validates :description, length: {maximum: Settings.card.description.length}
  validates_datetime :deadline, presence: true, allow_nil: true

  scope :opened, ->{where closed: false}
  scope :closed, ->{where closed: true}
  scope :last_position, ->{maximum :position}
  scope :order_by_updated_at, ->{order updated_at: :desc}
  scope :of_user, (lambda do |user_id|
    joins(list: {board: :user_boards})
      .where(user_boards: {user_id: user_id})
  end)

  after_create :create_activity
  after_update :deprecation_after_update

  private

  def create_activity
    activity = list.board.activities.build user_id: user_id
    activity.action = I18n.t(".create", name: name)
    activity.save
  end

  def deprecation_after_update
    if saved_change_to_name? && saved_change_to_description?
      update_activity "description", saved_changes[:description]
      update_activity "name", saved_changes[:name]
    elsif saved_change_to_name?
      update_activity "name", saved_changes[:name]
    elsif saved_change_to_description?
      update_activity "description", saved_changes[:description]
    end
  end

  def update_activity attribute, values
    activity = list.board.activities.build user_id: user_id
    activity.action = I18n.t(".update", attribute: attribute,
                                             card_name: name_before_last_save,
                                             value: values[1])
    activity.save
  end
end
