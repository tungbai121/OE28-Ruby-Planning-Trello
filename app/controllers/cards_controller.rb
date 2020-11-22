class CardsController < ApplicationController
  before_action :find_board, :check_permission, except: %i(index show new)
  before_action :find_list, :check_list_in_board, only: :create
  before_action :find_card, only: %i(edit update destroy)
  before_action :load_activities, only: %i(create update destroy)

  authorize_resource

  def create
    @card = @list.cards.build card_params.merge(position: position)
    @card.user_id = current_user.id
    if @card.save
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  def edit
    @attachment = Attachment.new
    respond_to :js
  end

  def update
    @card.user_id = current_user.id
    if @card.update card_params
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  def destroy
    if @card.destroy
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  private

  def card_params
    params.require(:card).permit Card::TAG_PARAMS
  end

  def find_board
    @board = Board.find params[:board_id]
  end

  def find_list
    @list = List.find params[:list_id]
  end

  def check_list_in_board
    return if @board.lists.include? @list

    flash[:danger] = t ".list_not_in_board"
    redirect_to @board
  end

  def find_card
    @card = Card.find params[:id]
  end

  def position
    lastpos = @list.cards.opened.last_position
    return lastpos + Settings.number.one if lastpos.present?

    Settings.number.zero
  end
end
