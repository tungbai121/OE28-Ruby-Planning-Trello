class BoardsController < ApplicationController
  before_action :user_board
  before_action :check_board, :check_member, only: :show

  def new
    @board = Board.new
  end

  def create
    @board = Board.new board_params
    if @board.save
      current_user.join_board @board, params[:type]
      flash[:success] = t ".success"
      redirect_to root_path
    else
      flash[:danger] = t ".fail"
      render :new
    end
  end

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

  def board_params
    params.require(:board).permit Board::PERMIT_ATTRIBUTES
  end
end
