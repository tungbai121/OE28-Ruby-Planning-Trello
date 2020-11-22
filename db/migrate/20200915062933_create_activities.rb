class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.string :action
      t.references :user, null: false, foreign_key: true
      t.references :board, null: false, foreign_key: true

      t.timestamps
    end
  end
end
