class ClosedController < ApplicationController
  before_action :load_user, only: %i(index)

  def index
    @closed_board = @user.join_boards.closed.order_created
    @closed_list = List.closed_lists(current_user.join_boards.ids).order_created
    @tags = Tag.of_user(current_user.id).closed.order_by_updated_at
  end

  private

  def load_user
    @user = User.find params[:user_id]
  end
end
