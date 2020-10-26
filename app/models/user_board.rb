class UserBoard < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(role_id starred).freeze

  enum role_id: {guest: -1, leader: 0, member: 1}

  belongs_to :user
  belongs_to :board

  validates :role_id, presence: true

  scope :by_board_id, (lambda do |board_id|
    where board_id: board_id if board_id.present?
  end)
  scope :by_user_id, ->(user_id){where user_id: user_id if user_id.present?}

  after_create :create_notification

  class << self
    def user_role user_id, board_id
      find_by user_id: user_id, board_id: board_id
    end
  end

  private

  def create_notification
    notification = board.notifications.build user_id: user.id
    notification.content = I18n.t(".boards.create.noti_create")
    notification.save
  end
end
