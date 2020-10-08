class TagsController < ApplicationController
  before_action :logged_in_user, :load_board,
                :check_permission, only: %i(create edit update)
  before_action :load_list, :check_list_in_board, only: :create
  before_action :load_tag, only: %i(edit update)
  before_action :load_notifications, only: %i(create update)

  def create
    @tag = @list.tags.build tag_params.merge(position: position)
    @tag.user_id = current_user.id
    if @tag.save
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  def edit
    respond_to :js
  end

  def update
    @tag.user_id = current_user.id
    if @tag.update tag_params
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
    @board = Board.find params[:board_id]
  end

  def load_list
    @list = List.find params[:list_id]
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
      redirect_to @board
    else
      flash[:danger] = t ".user_not_in_board"
      redirect_to root_url
    end
  end

  def load_tag
    @tag = Tag.find params[:id]
  end

  def position
    lastpos = @list.tags.opened.last_position
    return lastpos + Settings.number.one if lastpos.present?

    Settings.number.zero
  end
end
