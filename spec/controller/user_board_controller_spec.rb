require "rails_helper"

RSpec.describe UserBoardsController, type: :controller do
  let(:user_1) {FactoryBot.create :user}
  let(:user_2) {FactoryBot.create :user}
  let(:board1) {FactoryBot.create :board}
  let(:board2) {FactoryBot.create :board}
  let!(:user_board) {FactoryBot.create :user_board, user: user_1, board: board1, role_id: 0}
  let!(:user_board2) {FactoryBot.create :user_board, user: user_2, board: board1, role_id: 1}
  let(:board_notfound) {FactoryBot.create :board, closed: true}

  describe "PATCH #update" do
    before {sign_in user_1}
    subject(:relation2_role) {user_board2.role_id}
    subject(:relation1_role) {user_board.role_id}

    context "has role_id param" do
      it "when valid params" do
        patch :update, params: {id: user_board2.id, board_id: board1.id, user_id: user_2.id, user_boards: {role_id: "leader"}}, xhr: true
        user_board2.reload
        expect(relation2_role).to eq "leader"
      end

      it "when invalid user params" do
        patch :update, params: {id: user_board2.id, board_id: board1.id, user_id: nil, user_boards: {role_id: "leader"}}, xhr: true
        user_board2.reload
        expect(relation2_role).to eq "member"
      end

      it "when only one leader" do
        patch :update, params: {id: user_board.id, board_id: board1.id, user_id: user_1.id, user_boards: {role_id: "member"}}, xhr: true
        user_board.reload
        expect(relation1_role).to eq "leader"
      end
    end

    context "has no role_id param" do
      it "should fail when update" do
        patch :update, params: {id: user_board2.id, board_id: board1.id, user_id: user_2.id, user_boards: {role_id: nil}}, xhr: true
        user_board2.reload
        expect(relation2_role).to eq "member"
      end
    end
  end
end
