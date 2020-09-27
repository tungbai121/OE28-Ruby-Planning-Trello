class AddDefaultsToBoards < ActiveRecord::Migration[6.0]
  def change
    change_column :boards, :closed, :boolean, default: false
  end
end
