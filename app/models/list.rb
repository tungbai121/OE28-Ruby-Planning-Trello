class List < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(name).freeze

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
