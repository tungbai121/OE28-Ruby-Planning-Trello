class AddDefaultsToCards < ActiveRecord::Migration[6.0]
  def change
    change_column :cards, :completed, :boolean, default: false
    change_column :cards, :closed, :boolean, default: false
  end
end
