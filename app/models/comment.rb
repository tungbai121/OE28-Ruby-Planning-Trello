class Comment < ApplicationRecord
  has_many :attachments, as: :attachmentable, dependent: :delete_all
  belongs_to :user
  belongs_to :tag
end
