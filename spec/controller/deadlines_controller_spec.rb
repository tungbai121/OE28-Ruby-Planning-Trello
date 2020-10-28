require "rails_helper"

describe DeadlinesController, type: :controller do
  let(:board) {FactoryBot.create :board}
  let(:list) {FactoryBot.create :list, board: board}
  let(:tag) {FactoryBot.create :tag, list: list}
  let(:user) {FactoryBot.create :user}

  before do
    sign_in user
    set_permission user, board
  end

  describe "actions" do
    describe "POST #create" do
      let(:params) {{tag: {deadline: Faker::Time.forward(days: 20, period: :evening)}, board_id: board.id, tag_id: tag.id}}

      subject {tag.deadline}

      context "when create deadline success" do
        before do
          post :create, params: params, xhr: true
          tag.reload
        end
        it {is_expected.to eq params[:tag][:deadline]}
      end

      context "when create deadline failed" do
        before do
          allow_any_instance_of(Tag).to receive(:update).and_return false
          post :create, params: params, xhr: true
          tag.reload
        end
        it {is_expected.not_to eq params[:tag][:deadline]}
      end
    end

    describe "PATCH #update" do
      subject {tag.completed}

      context "when update deadline completed" do
        let(:params) {{tag: {completed: true}, board_id: board.id, tag_id: tag.id}}

        before do
          patch :update, params: params, xhr: true
          tag.reload
        end
        it {is_expected.to eq true}
      end

      context "when update deadline incompleted" do
        let(:params) {{tag: {completed: false}, board_id: board.id, tag_id: tag.id}}

        before do
          patch :update, params: params, xhr: true
          tag.reload
        end
        it {is_expected.to eq false}
      end
    end

    describe "DELETE #destroy" do
      let(:tag) {FactoryBot.create :tag, deadline: Faker::Time.forward(days: 20, period: :evening), list: list}
      let(:params) {{board_id: board.id, tag_id: tag.id}}

      subject {tag.deadline}

      context "when destroy deadline success" do
        before do
          delete :destroy, params: params, xhr: true
          tag.reload
        end
        it {is_expected.to eq nil}
      end

      context "when destroy deadline failed" do
        before do
          allow_any_instance_of(Tag).to receive(:update).and_return false
          delete :destroy, params: params, xhr: true
        end
        it {is_expected.not_to eq nil}
      end
    end
  end

  describe "methods" do
    describe "completed_update" do
      context "when failed" do
        let(:params) {{tag: {completed: true}, board_id: board.id, tag_id: tag.id}}

        before do
          allow_any_instance_of(Tag).to receive(:update).and_return false
          patch :update, params: params, xhr: true
        end
        it "is expected to flashes a failed message" do
          expect(flash.now[:danger]).to eq I18n.t ".deadlines.update.failed"
        end
      end
    end

    describe "incompleted_update" do
      context "when failed" do
        let(:params) {{tag: {completed: false}, board_id: board.id, tag_id: tag.id}}

        before do
          allow_any_instance_of(Tag).to receive(:update).and_return false
          patch :update, params: params, xhr: true
        end
        it "is expected to flashes a failed message" do
          expect(flash.now[:danger]).to eq I18n.t ".deadlines.update.failed"
        end
      end
    end
  end
end
