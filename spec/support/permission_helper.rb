module PermissionHelper
  def set_permission user, board
    board.users << user
    UserBoard.find_by(user_id: user.id, board_id: board.id).member!
  end
end
