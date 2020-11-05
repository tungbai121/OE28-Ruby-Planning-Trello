class LabelsController < ApplicationController
  before_action :find_board
  before_action :find_label, except: :create
  before_action :load_labels

  authorize_resource

  def create
    @label = @board.labels.build label_params
    if @label.save
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".fail"
    end
    respond_to :js
  end

  def update
    if @label.update label_params
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".fail"
    end
    respond_to :js
  end

  def destroy
    if @label.destroy
      flash.now[:primary] = t ".success"
    else
      flash.now[:danger] = t ".fail"
    end
    respond_to :js
  end

  private

  def find_board
    @board = Board.find_by id: params[:board_id]
    return if @board

    flash[:warning] = t ".cant_find"
    redirect_to root_path
  end

  def find_label
    @label = Label.find_by id: params[:id]

    return if @label

    flash[:warning] = t ".cant_find"
    redirect_to root_path
  end

  def label_params
    params.require(:label).permit Label::PERMIT_ATTRIBUTES
  end

  def load_labels
    @labels = @board.labels
  end
end
