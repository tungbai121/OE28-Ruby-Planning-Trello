class LabelsController < ApplicationController
  before_action :find_board, only: :create

  def create
    label = @board.labels.build label_params
    if label.save
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

    flash[:warning] = t ".cant_find"
    redirect_to root_path
  end

  def label_params
    params.require(:label).permit Label::PERMIT_ATTRIBUTES
  end
end
