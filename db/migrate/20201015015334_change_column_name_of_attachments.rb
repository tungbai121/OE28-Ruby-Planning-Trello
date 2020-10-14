class ChangeColumnNameOfAttachments < ActiveRecord::Migration[6.0]
  def change
    rename_column :attachments, :link, :content
  end
end
