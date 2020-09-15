class CreateBoards < ActiveRecord::Migration[6.0]
  def change
    create_table :boards do |t|
      t.string :name
      t.text :description
      t.boolean :status
      t.boolean :closed

      t.timestamps
    end
  end
end
