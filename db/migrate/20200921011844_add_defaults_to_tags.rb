class AddDefaultsToTags < ActiveRecord::Migration[6.0]
  def change
    change_column :tags, :completed, :boolean, default: false
    change_column :tags, :closed, :boolean, default: false
  end
end
