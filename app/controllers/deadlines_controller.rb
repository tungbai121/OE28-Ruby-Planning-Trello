class DeadlinesController < ApplicationController
  before_action :logged_in_user, :load_data,
                :check_permission, only: %i(create update destroy)
  def create
    deadline = params[:tag][:deadline]
    if @tag.update deadline: deadline
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  def update
    completed = params[:tag][:completed]
    if completed == "true"
      completed_update
    else
      incompleted_update
    end

    respond_to :js
  end

  def destroy
    if @tag.update deadline: nil, completed: false, completed_at: nil
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  private

  def load_data
    @board = Board.find params[:board_id]
    @tag = Tag.find params[:tag_id]
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

  def completed_update
    if @tag.update completed: true, completed_at: DateTime.now
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
  end

  def incompleted_update
    if @tag.update completed: false, completed_at: nil
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
  end
end