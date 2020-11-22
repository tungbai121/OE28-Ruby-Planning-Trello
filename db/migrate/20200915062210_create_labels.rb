class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.string :content
      t.references :board, null: false, foreign_key: true

      t.timestamps
    end
  end
end
