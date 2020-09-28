class ListsController < ApplicationController
  before_action :find_board

  def create
    @list = @board.lists.build list_params
    if @list.save
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fail"
    end
    redirect_to @board
  end

  private

  def find_board
    @board = Board.find_by id: params[:board_id]
    return if @board

    flash[:danger] = t ".cant_find"
    redirect_to root_path
  end

  def list_params
    params.require(:list).permit List::PERMIT_ATTRIBUTES
  end
end
