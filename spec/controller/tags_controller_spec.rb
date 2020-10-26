require "rails_helper"

describe TagsController, type: :controller do
  let(:board) {FactoryBot.create :board}
  let(:list) {FactoryBot.create :list, board: board}
  let(:user) {FactoryBot.create :user}

  before do
    login user
    set_permission user, board
  end

  describe "actions" do
    describe "POST #create" do
      let(:params) {{tag: {name: Faker::Name.name, description: Faker::Lorem.paragraph}, board_id: board.id, list_id: list.id}}

      context "when create tag success" do
        it {expect{post :create, params: params, xhr: true}.to change(Tag, :count).by 1}
      end

      context "when create tag failed" do
        before {params[:tag][:name] = nil}
        it {expect{post :create, params: params, xhr: true}.to change(Tag, :count).by 0}
      end
    end

    describe "GET #edit" do
      let(:tag) {FactoryBot.create :tag, list: list}
      let(:params) {{board_id: board.id, id: tag.id}}

      before {get :edit, params: params, xhr: true}
      it {expect(response).to have_http_status(200)}
    end

    describe "PATCH #update" do
      let(:tag) {FactoryBot.create :tag, list: list}
      let(:params) {{tag: {name: Faker::Name.name, description: Faker::Lorem.paragraph}, board_id: board.id, id: tag.id}}

      subject {Tag.find(tag.id).attributes}

      context "when update tag success" do
        before do
          patch :update, params: params, xhr: true
        end
        it {is_expected.not_to eq tag.attributes}
      end

      context "when update tag failed" do
        before do
          allow_any_instance_of(Tag).to receive(:update).and_return false
          patch :update, params: params, xhr: true
        end
        it {is_expected.to eq tag.attributes}
      end
    end

    describe "DELETE #destroy" do
      let!(:tag) {FactoryBot.create :tag, list: list}
      let(:params) {{board_id: board.id, id: tag.id}}

      context "when destroy tag success" do
        it {expect{delete :destroy, params: params, xhr: true}.to change(Tag, :count).by -1}
      end

      context "when destroy tag failed" do
        before {allow_any_instance_of(Tag).to receive(:destroy).and_return false}
        it {expect{delete :destroy, params: params, xhr: true}.to change(Tag, :count).by 0}
      end
    end
  end

  describe "methods" do
    describe "check_list_in_board" do
      context "when list not belongs to board" do
        let(:another_board) {FactoryBot.create :board}
        let(:another_list) {FactoryBot.create :list, board: another_board}
        let(:params) {{tag: {name: Faker::Name.name, description: Faker::Lorem.paragraph}, board_id: board.id, list_id: another_list.id}}

        before {post :create, params: params, xhr: true}
        it "is expected to redirect to board url" do
          expect(response).to redirect_to board
        end
      end
    end

    describe "check_permission" do
      let(:params) {{tag: {name: Faker::Name.name, description: Faker::Lorem.paragraph}, board_id: board.id, list_id: list.id}}

      context "when user has not joined the board" do
        before do
          board.add_users.delete user
          post :create, params: params, xhr: true
        end
        it "is expected to redirect to root url" do
          expect(response).to redirect_to root_url
        end
      end

      context "when user has no permission to the board" do
        before do
          UserBoard.find_by(user_id: user.id, board_id: board.id).update role_id: -1
          post :create, params: params, xhr: true
        end
        it "is expected to redirect to board url" do
          expect(response).to redirect_to board
        end
      end
    end
  end
end
