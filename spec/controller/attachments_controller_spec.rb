require "rails_helper"

describe AttachmentsController, type: :controller do
  let(:board) {FactoryBot.create :board}
  let(:list) {FactoryBot.create :list, board: board}
  let(:tag) {FactoryBot.create :tag, list: list}
  let(:user) {FactoryBot.create :user}

  before do
    sign_in user
    set_permission user, board
  end

  describe "POST #create" do
    let(:params) {{attachment: {content: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/files/avatar.jpg")}, board_id: board.id, tag_id: tag.id}}

    context "when create attachment success" do
      it {expect{post :create, params: params, xhr: true}.to change(Attachment, :count).by 1}
    end

    context "when create attachment failed" do
      before {allow_any_instance_of(Attachment).to receive(:save).and_return false}
      it {expect{post :create, params: params, xhr: true}.to change(Attachment, :count).by 0}
    end
  end
end
