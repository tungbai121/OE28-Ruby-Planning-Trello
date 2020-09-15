class CreateTagUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :tag_users do |t|
      t.integer :tag_id
      t.integer :user_id

      t.timestamps
    end
  end
end
