class AddDefaultsToUserBoards < ActiveRecord::Migration[6.0]
  def change
    change_column :user_boards, :starred, :boolean, default: false
  end
end
