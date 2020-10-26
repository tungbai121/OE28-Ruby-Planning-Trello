class AddIndexsToTagLabels < ActiveRecord::Migration[6.0]
  def change
    add_index :tag_labels, [:tag_id, :label_id], unique: true
  end
end
