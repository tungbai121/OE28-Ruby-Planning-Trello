class AddDefaultsRoleIdToUserBoards < ActiveRecord::Migration[6.0]
  def change
    change_column :user_boards, :role_id, :integer, default: 0
  end
end
