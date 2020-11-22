class CreateCardUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :card_users do |t|
      t.references :card, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
