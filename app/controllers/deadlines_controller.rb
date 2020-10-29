class DeadlinesController < ApplicationController
  before_action :load_data, :check_permission, only: %i(create update destroy)

  def create
    if @tag.update deadline: params[:tag][:deadline]
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  def update
    if params[:tag][:completed].eql? "true"
      completed_update
    else
      incompleted_update
    end
    respond_to :js
  end

  def destroy
    if @tag.update deadline: nil, completed: false, completed_at: nil
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  private

  def load_data
    @board = Board.find params[:board_id]
    @tag = Tag.find params[:tag_id]
  end

  def completed_update
    if @tag.update completed: true, completed_at: DateTime.now
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
  end

  def incompleted_update
    if @tag.update completed: false, completed_at: nil
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
  end
end
