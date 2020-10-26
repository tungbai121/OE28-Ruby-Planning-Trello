class Attachment < ApplicationRecord
  ATTACHMENT_PARAMS = %i(name content).freeze
  belongs_to :attachmentable, polymorphic: true

  mount_uploader :content, AttachmentUploader

  delegate :url, :size, :filename, to: :content

  validates :name, presence: true,
    length: {maximum: Settings.attachment.name.length},
    allow_nil: true

  after_create :update_attachment_attributes

  scope :order_by_created_at, ->{order created_at: :desc}

  private

  def update_attachment_attributes
    self.name = content.filename if content.present?
  end
end
