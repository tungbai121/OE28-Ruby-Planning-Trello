class BoardsController < ApplicationController
  before_action :user_board
  before_action :check_board, :check_member, only: :show

  def new; end

  def show
    @labels = @board.labels
  end

  private

  def check_member
    @relation = UserBoard.find_by user_id: current_user.id, board_id: @board.id
    return if @relation

    flash[:danger] = t ".nomember"
    redirect_to root_path
  end

  def check_board
    @board = Board.find_by id: params[:id]
    return if @board

    flash[:danger] = t ".cant_find"
    redirect_to root_path
  end
end
