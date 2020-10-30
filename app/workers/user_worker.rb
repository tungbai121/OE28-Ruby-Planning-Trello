class UserWorker
  include Sidekiq::Worker

  def perform user_id, board_id
    user_send = User.find user_id
    UserMailer.user_invitation(user_send, board_id).deliver_now
  end
end
