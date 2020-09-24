class UserBoard < ApplicationRecord
  enum role_id: {leader: 0, member: 1}

  belongs_to :user
  belongs_to :board
end
