class CloseTagsController < ApplicationController
  before_action :load_data, :check_permission, only: %i(create destroy)
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

  def position
    lastpos = @list.tags.opened.last_position
    return lastpos + Settings.number.one if lastpos.present?

    Settings.number.zero
  end
end
