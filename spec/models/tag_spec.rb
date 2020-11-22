require "rails_helper"

describe Tag, type: :model do
  let(:tag) {FactoryBot.create :tag}

  describe "factories" do
    it "is expected to be valid" do
      expect(tag).to be_valid
    end
  end

  describe "associations" do
    {labels: :tag_labels, users: :tag_users}.each do |model, eloquent|
      it {is_expected.to have_many(model).through eloquent}
    end

    [:tag_labels, :tag_users, :comments, :attachments, :checklists].each do |model|
      it {is_expected.to have_many model}
    end

    it {is_expected.to belong_to :list}
  end

  describe "validations" do
    context "when missing name" do
      it {is_expected.to validate_presence_of :name}
    end

    context "when name length is greater than #{Settings.tag.name.length} characters" do
      it {is_expected.to validate_length_of(:name).is_at_most Settings.tag.name.length}
    end

    context "when description length is greater than #{Settings.tag.description.length} characters" do
      it {is_expected.to validate_length_of(:description).is_at_most Settings.tag.description.length}
    end

    context "when deadline format is invalid" do
      it {is_expected.to_not allow_value("1f/5t/2020").for :deadline}
    end
  end

  describe "scopes" do
    let!(:board) {FactoryBot.create :board}
    let!(:user) {FactoryBot.create :user}
    let!(:user_board) {FactoryBot.create :user_board, board_id: board.id, user_id: user.id}
    let!(:list) {FactoryBot.create :list, board_id: board.id}
    let(:tag) {FactoryBot.create :tag, list_id: list.id}
    let(:opened_tag) {FactoryBot.create :tag, closed: false, list_id: list.id}
    let(:closed_tag) {FactoryBot.create :tag, closed: true, list_id: list.id}
    let!(:tag_last) {FactoryBot.create :tag, position: 10, list_id: list.id}

    describe ".opened" do
      it "is expected to return opened tags" do
        expect(Tag.opened).to include opened_tag
      end
    end

    describe ".closed" do
      it "is expected to return closed tags" do
        expect(Tag.closed).to include closed_tag
      end
    end

    describe ".last_position" do
      it "is expected to return the last position" do
        expect(Tag.last_position).to eq tag_last.position
      end
    end

    describe ".order_by_updated_at" do
      before do
        tag.update name: Faker::Name.name
        tag_last.update description: Faker::Quote.famous_last_words
      end
      it "is expected to return all tags order by newest updates" do
        expect(Tag.order_by_updated_at).to eq [tag_last, tag]
      end
    end

    describe ".of_user" do
      it "is expected to return all tags of user" do
        expect(Tag.of_user user.id).to include tag
      end
    end
  end

  describe "callbacks" do
    describe "create" do
      it {is_expected.to callback(:create_activity).after :create}
    end

    describe "update" do
      context "when update name and description" do
        before {tag.update name: Faker::Name.name, description: Faker::Quote.famous_last_words}
        it {is_expected.to callback(:deprecation_after_update).after :update}
      end

      context "when update name" do
        before {tag.update name: Faker::Name.name}
        it {is_expected.to callback(:deprecation_after_update).after :update}
      end

      context "when update description" do
        before {tag.update description: Faker::Quote.famous_last_words}
        it {is_expected.to callback(:deprecation_after_update).after :update}
      end
    end
  end
end
