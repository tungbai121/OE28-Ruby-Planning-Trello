module PermissionHelper
  def set_permission user, board
    board.add_users << user
    UserBoard.find_by(user_id: user.id, board_id: board.id).member!
  end
end
