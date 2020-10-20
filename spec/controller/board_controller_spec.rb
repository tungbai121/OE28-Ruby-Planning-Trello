require "rails_helper"

RSpec.describe BoardsController, type: :controller do
  let(:user_1) {FactoryBot.create :user}
  let(:board1) {FactoryBot.create :board}
  let!(:user_board) {FactoryBot.create :user_board, user: user_1, board: board1}
  let(:board_notfound) {FactoryBot.create :board, closed: true}

  context "As a guest" do
    before {nil_session}

    describe "GET #new" do
      before {get :new}
      it {expect(response).to redirect_to login_url}
    end

    describe "POST #create" do
      before{post :create, params: {board: board1}}
      it {expect(response).to redirect_to login_url}
    end

    describe "GET #show" do
      before{post :create, params: {board: board1}}
      it {expect(response).to redirect_to login_url}
    end

    describe "PATCH #update" do
      before{patch :update, params: {id: board1.id, board_id: board1.id, board: {user_id: user_1.id, name: "Updated name"}}, xhr: true}
      it {expect(response).to redirect_to login_url}
    end

    describe "DELETE #destroy" do
      let!(:board_destroy) {FactoryBot.create :board}
      before {delete :destroy, params: {id: board_destroy.id}}
      it {expect(response).to redirect_to login_url}
    end

    describe "PATCH #update_board_status" do
      before {patch :update_board_status, params: {id: board1.id, board_id: board1.id, board_status: Faker::Number.between(from: 0, to: 1)}}
      it {expect(response).to redirect_to login_url}
    end

    describe "PATCH #update_board_closed" do
      before {patch :update_board_closed, params: {id: board1.id, board_id: board1.id, board_status: Faker::Number.between(from: 0, to: 1)}}
      it {expect(response).to redirect_to login_url}
    end
  end

  context "As a authenticated user" do
    before {login user_1}

    describe "GET #new" do
      before {get :new}
      it {expect(response).to render_template :new}
    end

    describe "POST #create" do
      it "when valid params" do
        post :create, params: {board: {name: "new board", description: "description"}}
        expect(response).to redirect_to root_url
      end

      it "when invalid params" do
        post :create, params: {board: {name: nil, description: "description"}}
        expect(response).to render_template :new
      end
    end

    describe "GET #show" do
      context "as a authenticated user and a member" do
        let(:board2) {FactoryBot.create :board}
        let!(:user_board2) {FactoryBot.create :user_board, user: user_1, board: board2}
        let!(:label1) {FactoryBot.create :label, board: board2}
        before {get :show, params: {id: board2.id}}
        it {expect(response).to render_template :show}
      end

      context "as a authenticated user but the board is closed" do
        let(:board3) {FactoryBot.create :board, closed: true}
        let!(:user_board2) {FactoryBot.create :user_board, user: user_1, board: board3}
        let!(:label1) {FactoryBot.create :label, board: board3}
        before {get :show, params: {id: board3.id}}
        it {expect(response).to redirect_to root_url}
      end

      context "show an closed board and not member" do
        before {get :show, params: {id: board_notfound.id}}
        it {expect(response).to redirect_to root_url}
      end
    end

    describe "PATCH #update" do
      it "when valid params" do
        patch :update, params: {id: board1.id, board_id: board1.id, board: {user_id: user_1.id, name: "Updated name"}}, xhr: true
        board1.reload
        expect(board1.name).to eq "Updated name"
      end

      it "when invalid name" do
        patch :update, params: {id: board1.id, board_id: board1.id, board: {user_id: user_1.id, name: nil}}, xhr: true
        board1.reload
        expect(board1.name).not_to eq "Updated name"
      end
    end

    describe "DELETE #destroy" do
      context "when valid params" do
        let!(:board_destroy) {FactoryBot.create :board}

        it "when valid params" do
          delete :destroy, params: {id: board_destroy.id}, xhr: true
          expect(Board.all).not_to include(board_destroy)
        end
      end

      context "when invalid params" do
        let!(:board_destroy_2) {FactoryBot.create :board}

        before do
          allow_any_instance_of(Board).to receive(:destroy).and_return false
          delete :destroy, params: {id: board_destroy_2.id}, xhr: true
        end

        it "flash error message" do
          expect(flash[:danger]).to eq "Can't delete"
        end
      end
    end

    describe "PATCH #update_board_status" do
      it "when status public" do
        patch :update_board_status, params: {id: board1.id, board_id: board1.id, board_status: 1}, xhr: true
        expect(response).to have_http_status(200)
      end

      it "when status private" do
        patch :update_board_status, params: {id: board1.id, board_id: board1.id, board_status: 0}, xhr: true
        expect(response).to have_http_status(200)
      end
    end

    describe "PATCH #update_board_closed" do
      it "when status public" do
        patch :update_board_closed, params: {id: board1.id, board_id: board1.id, board_status: 1}, xhr: true
        expect(response).to redirect_to root_url
      end

      it "when status private" do
        patch :update_board_closed, params: {id: board1.id, board_id: board1.id, board_status: 0}, xhr: true
        expect(response).to redirect_to root_url
      end

      it "should return to root" do
        patch :update_board_closed, params: {id: board1.id, board_id: nil, board_status: 0}, xhr: true
        expect(response).to redirect_to root_url
      end
    end
  end
end
