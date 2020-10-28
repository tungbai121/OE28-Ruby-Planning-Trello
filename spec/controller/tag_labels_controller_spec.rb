require "rails_helper"

describe TagLabelsController, type: :controller do
  let(:board) {FactoryBot.create :board}
  let(:user) {FactoryBot.create :user}
  let(:tag) {FactoryBot.create :tag}
  let(:label) {FactoryBot.create :label, board_id: board.id}

  before do
    sign_in user
    set_permission user, board
  end

  describe "actions" do
    describe "POST #create" do
      let(:params) {{board_id: board.id, tag_id: tag.id, label: [label.id]}}

      context "when add labels to tag success" do
        it {expect{post :create, params: params, xhr: true}.to change(TagLabel, :count).by params[:label].size}
      end

      context "when add labels to tag failed" do
        before do
          allow(TagLabel).to receive(:import).and_return false
          post :create, params: params, xhr: true
        end
        it "is expected to flashed a failed message" do
          expect(flash.now[:danger]).to eq I18n.t ".tag_labels.create.fail"
        end
      end
    end

    describe "GET #edit" do
      let(:params) {{board_id: board.id, tag_id: tag.id}}

      before {get :edit, params: params, xhr: true}
      it {expect(response).to have_http_status(200)}
    end

    describe "DELETE #destroy" do
      let(:params) {{board_id: board.id, tag_id: tag.id, label_id: label.id}}

      before {tag.labels << label}

      context "when remove label from tag success" do
        it {expect{delete :destroy, params: params, xhr: true}.to change(TagLabel, :count).by -1}
      end

      context "when remove label from tag failed" do
        before {allow_any_instance_of(TagLabel).to receive(:destroy).and_return false}
        it {expect{delete :destroy, params: params, xhr: true}.to change(TagLabel, :count).by 0}
      end
    end
  end

  describe "methods" do
    describe "find_relation" do
      let(:params) {{board_id: board.id, tag_id: tag.id, label_id: label.id}}

      context "when label hasn't been added to the tag" do
        before {delete :destroy, params: params, xhr: true}
        it "is expected to redirect to root url" do
          expect(response).to redirect_to root_url
        end
      end
    end
  end
end
