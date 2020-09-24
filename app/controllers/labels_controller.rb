class LabelsController < ApplicationController
  before_action :find_board
  before_action :find_label, except: :create

  def create
    label = @board.labels.build label_params
    if label.save
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fail"
    end
    redirect_to @board
  end

  def update
    if @label.update label_params
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fail"
    end
    redirect_to @board
  end

  def destroy
    if @label.destroy
      flash[:primary] = t ".success"
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

  def find_label
    @label = Label.find_by id: params[:label_id]
    return if @label

    flash[:warning] = t ".cant_find"
    redirect_to root_path
  end

  def label_params
    params.require(:label).permit Label::PERMIT_ATTRIBUTES
  end
end