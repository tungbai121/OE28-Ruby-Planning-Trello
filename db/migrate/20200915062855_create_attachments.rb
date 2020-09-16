class CreateAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :attachments do |t|
      t.string :name
      t.text :link
      t.integer :attachmentable_id
      t.string :attachmentable_type

      t.timestamps
    end
  end
end
