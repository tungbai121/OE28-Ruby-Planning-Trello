require "rails_helper"

describe CloseTagsController, type: :controller do
  let(:board) {FactoryBot.create :board}
  let(:list) {FactoryBot.create :list, board: board}
  let(:user) {FactoryBot.create :user}

  subject {tag.closed}

  before do
    login user
    set_permission user, board
  end

  describe "POST #create" do
    let(:tag) {FactoryBot.create :tag, closed: false, list: list}
    let(:params) {{board_id: board.id, list_id: list.id, id: tag.id}}

    context "when close tag success" do
      before do
        post :create, params: params, xhr: true
        tag.reload
      end
      it {is_expected.to eq true}
    end

    context "when close tag failed" do
      before do
        allow_any_instance_of(Tag).to receive(:update).and_return false
        post :create, params: params, xhr: true
        tag.reload
      end
      it {is_expected.to eq false}
    end
  end

  describe "DELETE #destroy" do
    let(:tag) {FactoryBot.create :tag, closed: true, list: list}
    let(:params) {{board_id: board.id, list_id: list.id, id: tag.id}}

    context "when restore tag success" do
      before do
        delete :destroy, params: params, xhr: true
        tag.reload
      end
      it {is_expected.to eq false}
    end

    context "when restore tag failed" do
      before do
        allow_any_instance_of(Tag).to receive(:update).and_return false
        delete :destroy, params: params, xhr: true
        tag.reload
      end
      it {is_expected.to eq true}
    end
  end
end
