class Attachment < ApplicationRecord
  ATTACHMENT_PARAMS = %i(content).freeze
  belongs_to :attachmentable, polymorphic: true

  mount_uploader :content, AttachmentUploader

  delegate :url, :size, :filename, to: :content

  before_save :update_attachment_attributes

  scope :order_by_created_at, ->{order created_at: :desc}

  private

  def update_attachment_attributes
    self.name = content.filename if content.present?
  end
end
