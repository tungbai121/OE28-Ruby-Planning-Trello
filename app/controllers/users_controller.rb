class UsersController < ApplicationController
  before_action :logged_in_user, :load_user, only: %i(show edit update)
  before_action :correct_user, only: %i(edit update)
  before_action :load_user_closed, only: :closed

  def show; end

  def edit
    redirect_to @user
  end

  def update
    if @user.update user_params
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  def closed
    @closed_board = @user.join_boards.closed
    @closed_list = List.closed_lists current_user.join_boards.ids
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".user_not_found"
    redirect_to root_url
  end

  def load_user_closed
    @user = User.find params[:user_id]
  end

  def correct_user
    redirect_to @user unless current_user? @user
  end
end
