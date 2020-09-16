class AddListToTags < ActiveRecord::Migration[6.0]
  def change
    add_reference :tags, :list, null: false, foreign_key: true
  end
end
