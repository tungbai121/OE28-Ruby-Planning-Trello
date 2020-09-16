class Attachment < ApplicationRecord
  belongs_to :attachmentable, polymorphic: true
end
