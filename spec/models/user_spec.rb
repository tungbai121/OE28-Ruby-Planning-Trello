require "rails_helper"
require "faker"

describe User, type: :model do
  let(:board) {FactoryBot.create :board}
  let(:user) {FactoryBot.create :user}
  let(:user2) {FactoryBot.create :user}
  let(:user_board) {FactoryBot.create :user_board, user: user, board: board}

  describe "#join_board" do
    before {user.join_board board, Faker::Number.between(from: 0, to: 1)}
    it "join success" do
      expect(user.boards).to include board
    end
  end

  describe "#is_leader?" do
    before {user_board}
    it "is in board" do
      expect(user.is_leader? board).not_to be_nil
    end
  end
end
