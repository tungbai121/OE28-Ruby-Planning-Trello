class CheckedChecklistsController < ApplicationController
  before_action :load_data, :find_checklist,
                :check_permission, only: :update

  def update
    if @checklist.update checked: params[:checklist][:checked]
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  private

  def load_data
    @board = Board.find params[:board_id]
    @card = Card.find params[:card_id]
  end

  def find_checklist
    @checklist = Checklist.find params[:id]
  end
end
