class AddIndexsToUserBoards < ActiveRecord::Migration[6.0]
  def change
    add_index :user_boards, [:user_id, :board_id], unique: true
  end
end
