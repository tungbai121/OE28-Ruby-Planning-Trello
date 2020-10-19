require "rails_helper"

describe Board, type: :model do
  let(:board) {FactoryBot.create :board}
  let(:user) {FactoryBot.create :user}
  let!(:list) {FactoryBot.create :list, board: board}
  let!(:list2) {FactoryBot.create :list, board: board}
  let(:greater_lists) {List.greater 0}
  let(:less_lists) {List.less 21}

  describe "Validations" do
    it "has a valid factory" do
      expect(list).to be_valid
    end

    it "is invalid without name" do
      expect(FactoryBot.build :list, name: nil).not_to be_valid
    end
  end

  describe "Scopes" do
    describe ".less" do
      it "have less position lists" do
        expect(List.less 20).not_to be_nil
      end
    end

    describe ".greater" do
      before {FactoryBot.create :list, position: 5}
      it "have greater position lists" do
        expect(List.greater 5).not_to be_nil
      end
    end
  end

  describe "#update_notification" do
    it "valid factory" do
      list.update name: "Update name"
      expect(board.notifications.build user_id: user.id, content: "Notification content").to be_valid
    end

    it "invalid factory" do
      list.update name: "Update name"
      expect(board.notifications.build user_id: user.id, content: nil).not_to be_valid
    end
  end

  describe ".increase_position" do
    it "return updated lists" do
      expect(List.increase_position greater_lists).to be_truthy
    end
  end

  describe ".decrease_position" do
    it "return updated lists" do
      expect(List.decrease_position less_lists).to be_truthy
    end
  end
end
