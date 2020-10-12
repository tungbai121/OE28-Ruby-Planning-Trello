class JoinTagsController < ApplicationController
  before_action :logged_in_user, :load_data,
                :check_permission, only: %i(create destroy)

  def create
    if @tag.users.include? current_user
      flash[:danger] = t ".user_in_tag"
    elsif @tag.users << current_user
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".failed"
    end
    redirect_to @board
  end

  def destroy
    if @tag.users.exclude? current_user
      flash[:danger] = t ".user_not_in_tag"
    elsif @tag.users.delete current_user
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".failed"
    end
    redirect_to @board
  end

  private

  def load_data
    @board = Board.find params[:board_id]
    @tag = Tag.find params[:id]
  end

  def check_permission
    permission = current_user.user_boards.find_by board_id: @board.id
    if permission
      return if permission.leader? || permission.member?

      flash[:danger] = t ".permission_denied"
      redirect_to @board
    else
      flash[:danger] = t ".user_not_in_board"
      redirect_to root_url
    end
  end
end
