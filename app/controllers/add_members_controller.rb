class AddMembersController < ApplicationController
  before_action :find_user, only: :new
  before_action :find_board, only: :edit

  def new
    @user.send_email_join @board.id
    flash[:success] = t ".success"
    redirect_to @board
  end

  def edit
    member_connection = UserBoard.new user_id: params[:id],
      board_id: params[:board_id],
      role_id: :member
    if member_connection.save
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fail"
    end
    redirect_to @board
  end

  private

  def find_user
    @user = User.find_by email: params[:email]
    @board = Board.find_by id: params[:board_id]
    return if @user && @board

    flash[:danger] = t ".cant_find_user"
    redirect_to @board
  end

  def find_board
    @board = Board.find_by id: params[:board_id]
    return if @board

    flash[:danger] = t ".cant_find"
    redirect_to root_path
  end
end
