require "rails_helper"

describe TagLabel, type: :model do
  let(:board) {FactoryBot.create :board}
  let(:tag) {FactoryBot.create :tag}
  let(:label) {FactoryBot.create :label, board_id: board.id}
  let!(:tag_label) {FactoryBot.create :tag_label, tag: tag, label: label}

  describe ".find_relation" do
    it "is expected to return a TagLabel object" do
      expect((TagLabel.find_relation tag.id, label.id).id).to eq tag_label.id
    end
  end
end
