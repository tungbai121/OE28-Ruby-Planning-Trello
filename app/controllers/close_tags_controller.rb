class CloseTagsController < ApplicationController
  before_action :logged_in_user, :load_data,
                :check_permission, only: %i(create destroy)
  def create
    if @tag.update closed: true, position: nil
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  def destroy
    if @tag.update closed: false, position: position
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  private

  def load_data
    @board = Board.find params[:board_id]
    @list = List.find params[:list_id]
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

  def position
    lastpos = @list.tags.opened.last_position
    return lastpos + Settings.number.one if lastpos.present?

    Settings.number.zero
  end
end
