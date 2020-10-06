class CreateChecklists < ActiveRecord::Migration[6.0]
  def change
    create_table :checklists do |t|
      t.string :name
      t.boolean :checked

      t.timestamps
    end
  end
end
