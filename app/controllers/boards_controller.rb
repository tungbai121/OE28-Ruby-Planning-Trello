class BoardsController < ApplicationController
  before_action :logged_in_user
  before_action :user_board
  before_action :check_board, :check_member, only: :show
  before_action :find_board,
                only: %i(update update_board_status update_board_closed)

  def new
    @board = Board.new
  end

  def create
    @board = Board.new board_params
    if @board.save
      current_user.join_board @board, params[:type]
      flash[:success] = t ".success"
      redirect_to root_path
    else
      flash[:danger] = t ".fail"
      render :new
    end
  end

  def show
    @labels = @board.labels
    @tag = Tag.new
    @list = List.new
    @lists = @board.lists.opened
    @label = Label.new
  end

  def update
    if @board.update board_params
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".error"
    end
    respond_to :js
  end

  def update_board_status
    if params[:board_status].to_i.eql? Settings.data.confirm
      @board.update_attribute :status, Settings.data.confirm
    else
      @board.update_attribute :status, nil
    end
    flash[:success] = t ".success"
    respond_to :js
  end

  def update_board_closed
    @board.update_attribute :closed, params[:closed].to_i
    flash[:warning] = t ".closed"
    redirect_to root_path
  end

  private

  def check_member
    @relation = UserBoard.find_by user_id: current_user.id, board_id: @board.id
    return if @relation

    flash[:danger] = t ".nomember"
    redirect_to root_path
  end

  def check_board
    @board = Board.find_by id: params[:id]
    return unless @board.closed

    flash[:danger] = t ".cant_find"
    redirect_to root_path
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
