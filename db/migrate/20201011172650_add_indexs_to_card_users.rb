class AddIndexsToCardUsers < ActiveRecord::Migration[6.0]
  def change
    add_index :card_users, [:card_id, :user_id], unique: true
  end
end
