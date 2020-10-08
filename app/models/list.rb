class List < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(name closed position).freeze

  attr_accessor :user_id

  has_many :tags, ->{order :position}, dependent: :destroy
  belongs_to :board

  validates :name, presence: true,
    length: {maximum: Settings.validate.max_list_name}

  scope :opened, ->{where closed: false}
  scope :max_position, ->{maximum :position}
  scope :greater, (lambda do |position|
    where("position > ?", position) if position.present?
  end)
  scope :less, (lambda do |position|
    where("position < ?", position) if position.present?
  end)
  scope :not_id, ->(id){where.not id: id}
  scope :inside_board, ->(board_id){where board_id: board_id}
  scope :available_positions, ->{where.not position: nil}
  scope :positions, ->{select :position}
  scope :order_position, ->{order position: :asc}
  scope :closed_lists, ->(board_ids){where board_id: board_ids, closed: true}
  scope :order_created, ->{order created_at: :desc}

  after_create :create_notification
  before_update ->{update_notification("name", name_change[1])},
                if: :will_save_change_to_name?
  before_update ->{update_notification("position", position_change[1].to_s)},
                if: :will_save_change_to_position?

  private

  def create_notification
    notification = board.notifications.build user_id: user_id
    notification.content = [
      I18n.t(".lists.create.noti_create"),
      I18n.t(".lists.create.list"),
      name
    ].join(" ")
    notification.save
  end

  def update_notification attribute, new_value
    notification = board.notifications.build user_id: user_id
    notification.content = [
      I18n.t(".lists.create.noti_update"),
      I18n.t(".lists.create.list"),
      attribute,
      I18n.t(".lists.create.to"),
      new_value
    ].join(" ")
    notification.save
  end

  class << self
    def increase_position lists
      ActiveRecord::Base.transaction do
        lists.update_all("position = position + 1")
      end
    end

    def decrease_position lists
      ActiveRecord::Base.transaction do
        lists.update_all("position = position - 1")
      end
    end
  end
end
