class UserBoard < ApplicationRecord
  enum role_id: {leader: 0, member: 1}

  belongs_to :user
  belongs_to :board

  after_create :create_notification

  private

  def create_notification
    notification = board.notifications.build user_id: user.id
    notification.content = I18n.t(".boards.create.noti_create")
    notification.save
  end
end
