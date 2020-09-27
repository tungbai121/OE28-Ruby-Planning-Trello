class UserMailer < ApplicationMailer
  def user_invitation user, board_id
    @user = user
    @board_id = board_id
    mail to: @user.email, subject: t(".invitation")
  end
end
