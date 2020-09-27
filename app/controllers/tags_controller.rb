class TagsController < ApplicationController
  before_action :logged_in_user, :load_board, :load_list,
                :check_list_in_board,
                :check_permission, only: :create

  def create
    @tag = @list.tags.build tag_params.merge(position: position)

    if @tag.save
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  private

  def tag_params
    params.require(:tag).permit Tag::TAG_PARAMS
  end

  def load_board
    @board = Board.find_by id: params[:board_id]
    if @board
      return unless @board.closed

      flash[:danger] = t ".board_closed"
    else
      flash[:danger] = t ".board_not_found"
    end

    redirect_to root_url
  end

  def load_list
    @list = List.find_by id: params[:list_id]
    if @list
      return unless @list.closed

      flash[:danger] = t ".list_closed"
    else
      flash[:danger] = t ".list_not_found"
    end

    redirect_to @board
  end

  def check_list_in_board
    return if @board.lists.include? @list

    flash[:danger] = t ".list_not_in_board"
    redirect_to @board
  end

  def check_permission
    permission = UserBoard.find_by user_id: current_user.id, board_id: @board.id
    if permission
      return if permission.leader? || permission.member?

      flash[:danger] = t ".permission_denied"
    end

    flash[:danger] = t ".user_not_in_board"
    redirect_to root_url
  end

  def position
    lastpos = @list.tags.opened.last_position
    return lastpos + Settings.number.one if lastpos.present?

    Settings.number.zero
  end
end
