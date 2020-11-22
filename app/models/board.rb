class Board < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(name description status).freeze

  attr_accessor :user_id

  has_many :user_boards, class_name: UserBoard.name,
    foreign_key: :board_id, dependent: :destroy
  has_many :users, through: :user_boards, source: :user
  has_many :lists, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :labels, dependent: :destroy
  has_many :annoucements, as: :annoucementable, dependent: :destroy

  validates :name, presence: true,
    length: {maximum: Settings.validate.max_board_name}

  validates :description, presence: true,
    length: {maximum: Settings.validate.max_board_description}

  scope :of_user, (lambda do |user_id|
    includes(:user_boards).where(user_boards: {user_id: user_id})
  end)

  scope :opened, ->{where closed: false}
  scope :closed, ->{where closed: true}

  scope :starred, (lambda do
    includes(:user_boards).where(user_boards: {starred: true})
  end)
  scope :nonstarred, (lambda do
    includes(:user_boards).where(user_boards: {starred: false})
  end)

  scope :order_by_created_at, ->{order created_at: :desc}
  scope :by_name, ->(keyword){where("name LIKE ?", "%#{keyword}%")}
  scope :by_status, ->(status){where status: status}

  ransack_alias :board_info, :name_or_description
  ransack_alias :user_info, :users_name_or_users_email

  ransacker :created_at do
    Arel.sql("date(boards.created_at)")
  end

  after_create :set_leader, :create_activity
  after_update :deprecation_after_update

  class << self
    def ransackable_attributes _auth_object = nil
      %w(name description board_info user_info created_at)
    end

    def ransortable_attributes _auth_object = nil
      %w(name description created_at)
    end
  end

  private

  def set_leader
    UserBoard.create user_id: user_id, board_id: id, role_id: :leader
  end

  def create_activity
    Activity.create! user_id: user_id,
                     action: I18n.t(".action.create_board"),
                     board_id: id
  end

  def deprecation_after_update
    if saved_change_to_name?
      update_activity "name", saved_changes[:name]
    elsif saved_change_to_description?
      update_activity "description", saved_changes[:description]
    elsif saved_change_to_status?
      update_activity "status", saved_changes[:status]
    end
  end

  def update_activity attribute, values
    activity = activities.build user_id: user_id
    activity.action = I18n.t(".action.update_board", attribute: attribute,
                                             board_name: name_before_last_save,
                                             value: values[1])
    activity.save
  end
end
