require "rails_helper"

describe ChecklistsController, type: :controller do
  let(:board) {FactoryBot.create :board}
  let(:list) {FactoryBot.create :list, board: board}
  let(:tag) {FactoryBot.create :tag, list: list}
  let(:user) {FactoryBot.create :user}

  before do
    sign_in user
    set_permission user, board
  end

  describe "POST #create" do
    let(:params) {{checklist: {name: Faker::Name.name}, board_id: board.id, tag_id: tag.id}}

    context "when create checklist success" do
      it {expect{post :create, params: params, xhr: true}.to change(Checklist, :count).by 1}
    end

    context "when create checklist failed" do
      before {params[:checklist][:name] = nil}
      it {expect{post :create, params: params, xhr: true}.to change(Checklist, :count).by 0}
    end
  end

  describe "PATCH #update" do
    let(:checklist) {FactoryBot.create :checklist, tag: tag}
    let(:params) {{checklist: {name: Faker::Name.name}, board_id: board.id, tag_id: tag.id, id: checklist.id}}

    subject {Checklist.find(checklist.id).name}

    context "when update checklist success" do
      before {patch :update, params: params, xhr: true}
      it {is_expected.not_to eq checklist.name}
    end

    context "when update checklist failed" do
      before do
        params[:checklist][:name] = nil
        patch :update, params: params, xhr: true
      end
      it {is_expected.to eq checklist.name}
    end
  end

  describe "DELETE #destroy" do
    let!(:checklist) {FactoryBot.create :checklist, tag: tag}
    let(:params) {{board_id: board.id, tag_id: tag.id, id: checklist.id}}

    context "when destroy checklist success" do
      it {expect{delete :destroy, params: params, xhr: true}.to change(Checklist, :count).by -1}
    end

    context "when destroy checklist failed" do
      before {allow_any_instance_of(Checklist).to receive(:destroy).and_return false}
      it {expect{delete :destroy, params: params, xhr: true}.to change(Checklist, :count).by 0}
    end
  end
end
