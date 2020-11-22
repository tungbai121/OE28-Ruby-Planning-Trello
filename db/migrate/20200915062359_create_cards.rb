class CreateCards < ActiveRecord::Migration[6.0]
  def change
    create_table :cards do |t|
      t.string :name
      t.text :description
      t.integer :position
      t.datetime :deadline
      t.boolean :completed
      t.datetime :completed_at
      t.boolean :closed
      t.references :list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
