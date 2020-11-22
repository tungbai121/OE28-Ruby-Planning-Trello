class ChecklistsController < ApplicationController
  before_action :load_data, :check_permission, only: %i(create update destroy)
  before_action :find_checklist, only: %i(update destroy)

  authorize_resource

  def create
    @checklist = @card.checklists.build checklist_params

    if @checklist.save
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  def update
    if @checklist.update checklist_params
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  def destroy
    if @checklist.destroy
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  private

  def checklist_params
    params.require(:checklist).permit Checklist::CHECKLIST_PARAMS
  end

  def load_data
    @board = Board.find params[:board_id]
    @card = Card.find params[:card_id]
  end

  def find_checklist
    @checklist = Checklist.find params[:id]
  end
end
