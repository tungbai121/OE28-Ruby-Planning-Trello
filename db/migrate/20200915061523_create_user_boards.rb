class CreateUserBoards < ActiveRecord::Migration[6.0]
  def change
    create_table :user_boards do |t|
      t.integer :user_id
      t.integer :board_id
      t.integer :role_id
      t.boolean :starred

      t.timestamps
    end
  end
end
