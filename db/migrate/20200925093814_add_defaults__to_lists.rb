class AddDefaultsToLists < ActiveRecord::Migration[6.0]
  def change
    change_column :lists, :closed, :boolean, default: false
  end
end
