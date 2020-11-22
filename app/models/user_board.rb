class UserBoard < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(role_id starred).freeze

  enum role_id: {guest: -1, leader: 0, member: 1}

  belongs_to :user
  belongs_to :board

  scope :by_board_id, (lambda do |board_id|
    where board_id: board_id if board_id.present?
  end)
  scope :by_user_id, ->(user_id){where user_id: user_id if user_id.present?}

  class << self
    def user_role user_id, board_id
      find_by user_id: user_id, board_id: board_id
    end
  end
end
