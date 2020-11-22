class CreateCardLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :card_labels do |t|
      t.references :card, null: false, foreign_key: true
      t.references :label, null: false, foreign_key: true

      t.timestamps
    end
  end
end
