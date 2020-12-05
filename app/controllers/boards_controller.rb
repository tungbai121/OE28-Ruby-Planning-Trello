class BoardsController < ApplicationController
  before_action :check_board, only: :show
  before_action :check_board_destroy, only: :destroy
  before_action :find_board,
                only: %i(update update_board_status update_board_closed)
  before_action :check_member, only: %i(show update)
  before_action :load_activities, only: :update

  authorize_resource

  def new
    @board = Board.new
  end

  def create
    @board = Board.new board_params
    @board.user_id = current_user.id
    if @board.save
      flash[:success] = t ".success"
      redirect_to root_url
    else
      flash[:danger] = t ".failed"
      render :new
    end
  end

  def show
    @data = {
      labels: @board.labels,
      lists: @board.lists.opened.order_position,
      positions: List.inside_board(@board.id)
                     .available_positions
                     .order_position
                     .positions,
      activities: @board.activities.order_by_created_at,
      other_emails: User.exclude_ids(@board.users.ids).pluck(:email)
    }
    @list = List.new
    @card = Card.new
    @checklist = Checklist.new
  end

  def update
    @board.user_id = current_user.id
    if @board.update board_params
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".error"
    end
    @closed_board = current_user.boards.closed
    respond_to :js
  end

  def destroy
    if @board.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fail"
    end
    @closed_board = current_user.boards.closed
    respond_to :js
  end

  def update_board_status
    if params[:board_status].to_i.eql? Settings.data.confirm
      @board.update_column :status, Settings.data.confirm
    else
      @board.update_column :status, nil
    end
    flash[:success] = t ".success"
    respond_to :js
  end

  def update_board_closed
    @board.update_column :closed, params[:closed].to_i
    flash[:warning] = t ".closed"
    redirect_to root_path
  end

  private

  def check_member
    @relation = UserBoard.find_by user_id: current_user.id, board_id: @board.id
    return if @relation || @board.status?

    flash[:danger] = t ".nomember"
    redirect_to root_path
  end

  def check_board
    @board = Board.find params[:id]
    return unless @board.closed?

    flash[:danger] = t ".closed"
    redirect_to root_path
  end

  def check_board_destroy
    @board = Board.find params[:id]
  end

  def find_board
    @board = Board.find_by id: params[:board_id]
    return if @board

    flash[:danger] = t ".cant_find"
    redirect_to root_path
  end

  def board_params
    params.require(:board).permit Board::PERMIT_ATTRIBUTES
  end
end
