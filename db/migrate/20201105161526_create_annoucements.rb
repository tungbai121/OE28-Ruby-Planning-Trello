class CreateAnnoucements < ActiveRecord::Migration[6.0]
  def change
    create_table :annoucements do |t|
      t.string :content
      t.boolean :readed, default: false
      t.integer :annoucementable_id
      t.string :annoucementable_type
      t.references :user

      t.timestamps
    end

    add_index :annoucements, [:annoucementable_type, :annoucementable_id], name: :annoucement_polymorphic
  end
end
