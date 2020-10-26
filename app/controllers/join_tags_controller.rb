class JoinTagsController < ApplicationController
  before_action :logged_in_user, :load_data,
                :check_permission, only: %i(create destroy)

  def create
    if @tag.users.include? current_user
      flash[:danger] = t ".user_in_tag"
    elsif @tag.users.push current_user
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
end
