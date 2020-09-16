class CreateTagLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :tag_labels do |t|
      t.integer :tag_id
      t.integer :label_id

      t.timestamps
    end
  end
end
