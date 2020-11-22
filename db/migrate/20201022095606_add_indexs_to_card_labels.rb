class AddIndexsToCardLabels < ActiveRecord::Migration[6.0]
  def change
    add_index :card_labels, [:card_id, :label_id], unique: true
  end
end
