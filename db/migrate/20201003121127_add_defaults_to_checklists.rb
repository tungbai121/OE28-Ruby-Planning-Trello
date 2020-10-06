class AddDefaultsToChecklists < ActiveRecord::Migration[6.0]
  def change
    change_column :checklists, :checked, :boolean, default: false
  end
end
