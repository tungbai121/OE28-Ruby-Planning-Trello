require "rails_helper"

describe JoinTagsController, type: :controller do
  let(:board) {FactoryBot.create :board}
  let(:list) {FactoryBot.create :list, board: board}
  let(:tag) {FactoryBot.create :tag, list: list}
  let(:user) {FactoryBot.create :user}
  let(:params) {{board_id: board.id, id: tag.id}}

  before do
    sign_in user
    set_permission user, board
  end

  describe "actions" do
    describe "POST #create" do
      context "when user has joined tag" do
        let!(:tag_user) {FactoryBot.create :tag_user, tag: tag, user: user}

        before {post :create, params: params}
        it "is expected to flashes a user inside tag message" do
          expect(flash[:danger]).to eq I18n.t ".join_tags.create.user_in_tag"
        end
      end

      context "when user join tag success" do
        before {post :create, params: params}
        it "is expected to has user in the tag" do
          expect(tag.users).to include user
        end
      end

      context "when user join tag failed" do
        before do
          allow_any_instance_of(Tag).to receive_message_chain("users.include?").with user {false}
          allow_any_instance_of(Tag).to receive_message_chain("users.push").with user {false}
          post :create, params: params
        end
        it "is expected to flashes a falied message" do
          expect(flash[:danger]).to eq I18n.t ".join_tags.create.failed"
        end
      end
    end

    describe "DELETE #destroy" do
      context "when user hasn't joined tag" do
        before {delete :destroy, params: params}
        it "is expected to flashes a user not inside tag message" do
          expect(flash[:danger]).to eq I18n.t ".join_tags.destroy.user_not_in_tag"
        end
      end

      context "when user leave tag success" do
        let!(:tag_user) {FactoryBot.create :tag_user, tag: tag, user: user}

        before {delete :destroy, params: params}
        it "is expected to has no user inside tag" do
          expect(tag.users).not_to include user
        end
      end

      context "when user leave tag failed" do
        before do
          allow_any_instance_of(Tag).to receive_message_chain("users.exclude?").with user {false}
          allow_any_instance_of(Tag).to receive_message_chain("users.delete").with user {false}
          delete :destroy, params: params
        end
        it "is expected to flashes a failed message" do
          expect(flash[:danger]).to eq I18n.t ".join_tags.destroy.failed"
        end
      end
    end
  end
end
