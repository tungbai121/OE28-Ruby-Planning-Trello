require "rails_helper"

describe TagUsersController, type: :controller do
  let(:board) {FactoryBot.create :board}
  let(:user) {FactoryBot.create :user}
  let(:tag) {FactoryBot.create :tag}

  before do
    login user
    set_permission user, board
  end

  describe "actions" do
    describe "POST #create" do
      let(:params) {{board_id: board.id, tag_id: tag.id, user: [user.id]}}

      context "when add users to tag success" do
        it {expect{post :create, params: params, xhr: true}.to change(TagUser, :count).by params[:user].size}
      end

      context "when add users to tag failed" do
        before do
          allow(TagUser).to receive(:import).and_return false
          post :create, params: params, xhr: true
        end
        it "is expected to flashed a failed message" do
          expect(flash.now[:danger]).to eq I18n.t ".tag_users.create.fail"
        end
      end
    end

    describe "GET #edit" do
      let(:params) {{board_id: board.id, tag_id: tag.id}}

      before {get :edit, params: params, xhr: true}
      it {expect(response).to have_http_status(200)}
    end

    describe "DELETE #destroy" do
      let(:params) {{board_id: board.id, tag_id: tag.id, user_id: user.id}}

      context "when remove user from tag success" do
        let!(:tag_user) {FactoryBot.create :tag_user, tag: tag, user: user}

        it {expect{delete :destroy, params: params, xhr: true}.to change(TagUser, :count).by -1}
      end

      context "when remove user from tag failed" do
        let!(:tag_user) {FactoryBot.create :tag_user, tag: tag, user: user}

        before {allow_any_instance_of(TagUser).to receive(:destroy).and_return false}
        it {expect{delete :destroy, params: params, xhr: true}.to change(TagUser, :count).by 0}
      end
    end
  end

  describe "methods" do
    describe "find_relation" do
      let(:params) {{board_id: board.id, tag_id: tag.id, user_id: user.id}}

      context "when user hasn't been added to the tag" do
        before {delete :destroy, params: params, xhr: true}
        it "is expected to redirect to root url" do
          expect(response).to redirect_to root_url
        end
      end
    end
  end
end
