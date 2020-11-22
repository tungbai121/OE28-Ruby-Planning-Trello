require "rails_helper"

describe Board, type: :model do
  let(:board) {FactoryBot.create :board}
  let(:board2) {FactoryBot.create :board}
  let(:invalid_board_name) {FactoryBot.build :board, name: nil}
  let(:invalid_board_description) {FactoryBot.build :board, description: nil}
  let(:user) {FactoryBot.create :user}
  let!(:user_board) {FactoryBot.create :user_board, user: user, board: board}
  let!(:user_board2) {FactoryBot.create :user_board, user: user, board: board2, starred: true}

  describe "Validations" do
    it "has a valid factory" do
      expect(board).to be_valid
    end

    it "is invalid without a name" do
      expect(invalid_board_name).not_to be_valid
    end

    it "is invalid without description" do
      expect(invalid_board_description).not_to be_valid
    end
  end

  describe "Associations" do
    [:user_boards, :users, :lists, :activities, :labels].each do |model|
      it "has many model" do
        expect(board).to have_many model
      end
    end
  end

  describe "Scopes" do
    describe ".starred" do
      it "is starred board" do
        expect(Board.starred user.id).to include board2
      end
    end

    describe ".nonstarred" do
      it "is not starred board" do
        expect(Board.nonstarred user.id).to include board
      end
    end
  end

  describe "callbacks" do
    context "update name" do
      let(:board3) {FactoryBot.create :board}
      before {board3.update name: "Update name"}

      it "update activity" do
        is_expected.to callback(:update_activity).before(:update)
      end
    end

    context "update description" do
      let(:board3) {FactoryBot.create :board}
      before {board3.update description: "Update description"}

      it "update activity" do
        is_expected.to callback(:update_activity).before(:update)
      end
    end
  end
end
