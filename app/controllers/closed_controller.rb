class ClosedController < ApplicationController
  before_action :find_user, only: %i(index)

  def index
    @closed_board = @user.boards.closed.order_by_created_at
    @closed_list = List.closed_lists(current_user.boards.ids)
                       .order_by_created_at
    @cards = Card.of_user(current_user.id).closed.order_by_updated_at
  end

  private

  def find_user
    @user = User.find params[:user_id]
  end
end
