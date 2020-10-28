require "rails_helper"

RSpec.describe LabelsController, type: :controller do
  let(:user_1) {FactoryBot.create :user}
  let(:board1) {FactoryBot.create :board}
  let!(:user_board) {FactoryBot.create :user_board, user: user_1, board: board1}
  let(:label1) {FactoryBot.create :label, board: board1}

  describe "POST #create" do
    context "as a authenticated user" do
      before {sign_in user_1}

      it "when valid params" do
        post :create, params: {board_id: board1.id, label: {content: "new label", board: board1}}, xhr: true
        expect(Label.all.size).to eq 1
      end

      it "when invalid params" do
        post :create, params: {board_id: board1.id, label: {content: nil, board: board1}}, xhr: true
        expect(Label.all.size).to eq 0
      end

      it "when invalid board params" do
        post :create, params: {board_id: 100, label: {content: nil, board: board1}}, xhr: true
        expect(response).to redirect_to root_url
      end
    end
  end

  describe "PATCH #update" do
    context "as a authenticated user" do
      before {sign_in user_1}

      it "when valid params" do
        patch :update, params: {id: label1.id, board_id: board1.id, label: {content: "Updated content"}}, xhr: true
        label1.reload
        expect(label1.content).to eq "Updated content"
      end

      it "when invalid params" do
        patch :update, params: {id: label1.id, board_id: board1.id, label: {content: nil}}, xhr: true
        label1.reload
        expect(label1.content).not_to eq "Updated content"
      end

      it "when invalid label params" do
        patch :update, params: {id: 100, board_id: board1.id, label: {content: "Updated content"}}, xhr: true
        expect(response).to redirect_to root_url
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:label_destroy) {FactoryBot.create :label}

    context "when valid params" do
      before {sign_in user_1}

      it "when valid params" do
        delete :destroy, params: {id: label_destroy.id, board_id: board1.id}, xhr: true
        expect(Label.all).not_to include(label_destroy)
      end
    end


    context "when a failure label destroy" do
      let!(:label_destroy2) {FactoryBot.create :user, name: "test data"}

      before do
        allow_any_instance_of(Label).to receive(:destroy).and_return false
        delete :destroy, params: {id: label_destroy2.id, board_id: board1.id}, xhr: true
      end

      it "should redirect to admin_users_path" do
        expect(Label.all).to include(label_destroy)
      end
    end
  end
end
