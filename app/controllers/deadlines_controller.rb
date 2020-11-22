class DeadlinesController < ApplicationController
  before_action :load_data, :check_permission, only: %i(create update destroy)

  def create
    if @card.update deadline: params[:card][:deadline]
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  def update
    if params[:card][:completed].eql? "true"
      completed_update
    else
      incompleted_update
    end
    respond_to :js
  end

  def destroy
    if @card.update deadline: nil, completed: false, completed_at: nil
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

  def completed_update
    if @card.update completed: true, completed_at: DateTime.now
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
  end

  def incompleted_update
    if @card.update completed: false, completed_at: nil
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
  end
end
