class AddIndexsToTags < ActiveRecord::Migration[6.0]
  def change
    add_index :tags, [:position, :list_id], unique: true
  end
end
