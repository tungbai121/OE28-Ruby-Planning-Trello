class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.string :name
      t.text :description
      t.integer :position
      t.datetime :deadline
      t.boolean :completed
      t.datetime :completed_at
      t.boolean :closed

      t.timestamps
    end
  end
end
