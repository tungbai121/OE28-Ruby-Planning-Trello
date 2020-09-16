class AddTagToComments < ActiveRecord::Migration[6.0]
  def change
    add_reference :comments, :tag, null: false, foreign_key: true
  end
end
