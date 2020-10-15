require "rails_helper"

describe UserBoard, type: :model do
  let(:board) {FactoryBot.create :board}
  let(:user) {FactoryBot.create :user}
  let!(:user_board) {FactoryBot.create :user_board, user: user, board: board}

  describe "Scopes" do
    describe ".by_board_id" do
      context "when valid param" do
        it "return record" do
          expect(UserBoard.by_board_id board.id).to include user_board
        end
      end
    end
  end

  describe ".user_role" do
    it "find exist relation" do
      expect(UserBoard.user_role user.id, board.id).to eql user_board
    end

    it "find non exists board relation" do
      expect(UserBoard.user_role user.id, nil).to be_nil
    end

    it "find non exists user relation" do
      expect(UserBoard.user_role nil, board.id).to be_nil
    end
  end
end
