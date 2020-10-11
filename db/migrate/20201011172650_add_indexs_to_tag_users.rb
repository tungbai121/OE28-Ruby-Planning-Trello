class AddIndexsToTagUsers < ActiveRecord::Migration[6.0]
  def change
    add_index :tag_users, [:tag_id, :user_id], unique: true
  end
end
