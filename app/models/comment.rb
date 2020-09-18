class Comment < ApplicationRecord
  has_many :attachments, as: :attachmentable, dependent: :destroy
  belongs_to :user
  belongs_to :tag
end
