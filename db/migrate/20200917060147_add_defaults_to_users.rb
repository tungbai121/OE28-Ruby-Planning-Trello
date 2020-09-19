class AddDefaultsToUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :admin, :boolean, default: false
    change_column :users, :blocked, :boolean, default: false
  end
end
