require "rails_helper"

describe Attachment, type: :model do
  let(:tag) {FactoryBot.create :tag}
  let(:attachment) {FactoryBot.create :attachment, attachmentable_id: tag.id, attachmentable_type: tag.class}

  describe ".update_attachment_attributes" do
    before {attachment.send :update_attachment_attributes}
    it "is expected attachment name is file name" do
      expect(attachment.name).to eql attachment.content.filename  
    end
  end
end
