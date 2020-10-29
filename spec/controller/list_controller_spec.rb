require "rails_helper"

RSpec.describe ListsController, type: :controller do
  let(:user_1) {FactoryBot.create :user}
  let(:board1) {FactoryBot.create :board}
  let(:board2) {FactoryBot.create :board}
  let!(:user_board) {FactoryBot.create :user_board, user: user_1, board: board1}
  let!(:user_board2) {FactoryBot.create :user_board, user: user_1, board: board2}
  let!(:list2) {FactoryBot.create :list, position: 0, board: board2}
  let!(:list3) {FactoryBot.create :list, position: 1, board: board2}
  let!(:list4) {FactoryBot.create :list, position: 2, board: board2}
  let!(:list5) {FactoryBot.create :list, position: nil, board: board2, closed: true}

  describe "POST #create" do
    context "as a authenticated user" do
      before {sign_in user_1}

      it "when valid params" do
        post :create, params: {board_id: board1.id, list: {name: "new list"}}
        expect(response).to have_http_status(302)
      end

      it "when have other lists" do
        FactoryBot.create :list, position: 0, board: board1
        post :create, params: {board_id: board1.id, list: {name: "new list"}}
        expect(response).to have_http_status(302)
      end

      it "when invalid params" do
        post :create, params: {board_id: board1.id, list: {name: nil}}
        expect(response).to have_http_status(302)
      end

      it "when invalid board params" do
        post :create, params: {board_id: nil, list: {name: "new list"}}
        expect(response).to redirect_to root_url
      end
    end
  end

  describe "PATCH #update" do
    before {sign_in user_1}

    context "as a authenticated user" do
      it "when valid params" do
        patch :update, params: {id: list2.id, board_id: board1.id, list_id: list2.id, list: {name: "Updated name"}}
        list2.reload
        expect(list2.name).to eq "Updated name"
      end

      it "when invalid list params" do
        patch :update, params: {id: list2.id, board_id: board1.id, list_id: nil, list: {name: "Updated name"}}
        expect(response).to redirect_to root_url
      end

      it "when invalid list name" do
        patch :update, params: {id: list2.id, board_id: board1.id, list_id: list2.id, list: {name: nil}}
        expect(list2.name).not_to eq "Updated name"
      end
    end

    context "when restore position" do
      it "when have other lists" do
        patch :update, params: {id: list5.id, board_id: board2.id, list_id: list5.id, list: {closed: true}}
        list5.reload
        expect(list5.position).not_to be_nil
      end

      it "when have no other lists" do
        list2.destroy
        list3.destroy
        list4.destroy
        patch :update, params: {id: list5.id, board_id: board2.id, list_id: list5.id, list: {closed: true}}
        list5.reload
        expect(list5.position).not_to be_nil
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:list_destroy) {FactoryBot.create :list}

    context "when valid params" do
      before {sign_in user_1}

      it "when valid params" do
        delete :destroy, params: {id: list_destroy.id, board_id: board1.id}, xhr: true
        expect(List.all).not_to include(list_destroy)
      end
    end
  end

  describe "PATCH #change_position" do
    context "when valid params" do
      before {sign_in user_1}

      it "when move increase" do
        patch :change_position, params: {id: list2.id, board_id: board2.id, list_id: list2.id, position: 2}
        list2.reload
        expect(list2.position).to eq 2
      end

      it "when move increase" do
        patch :change_position, params: {id: list4.id, board_id: board2.id, list_id: list4.id, position: 0}
        list4.reload
        expect(list4.position).to eq 0
      end
    end
  end

  describe "PATCH #closed_list" do
    context "when valid params" do
      before do
        sign_in user_1
        patch :closed_list, params: {id: list2.id, board_id: board2.id, list_id: list2.id}
      end

      it "when valid params" do
        list2.reload
        expect(list2.position).to be_nil
      end
    end
  end
end
