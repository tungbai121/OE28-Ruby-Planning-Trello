class UserBoardsController < ApplicationController
  before_action :find_board,
                :find_relation,
                :find_all_relation,
                :check_leader, only: :update

  def update
    if @relation.update user_boards_params
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fail"
    end
    respond_to :js
  end

  private

  def check_leader
    return unless @user_boards
                  .group(:role_id)
                  .count["leader"].eql?(Settings.data.confirm) &&
                  user_boards_params[:role_id].eql?("member")

    flash[:danger] = t ".oneleader"
    redirect_to @board
  end

  def find_relation
    @relation = UserBoard.find_by user_id: params[:user_id],
                                  board_id: params[:board_id]
    return if @relation

    flash[:danger] = t ".fail"
    redirect_to @board
  end

  def find_all_relation
    @user_boards = UserBoard.by_board_id params[:board_id]
    return if @user_boards

    flash[:danger] = t ".fail"
    redirect_to @board
  end

  def find_board
    @board = Board.find params[:board_id]
  end

  def user_boards_params
    params.require(:user_boards).permit UserBoard::PERMIT_ATTRIBUTES
  end
end
