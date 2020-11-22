class CardUsersController < ApplicationController
  before_action :find_board, :find_card, :check_permission
  before_action :find_relation, only: :destroy

  def create
    user_ids = params[:user]
    new_relations = []
    user_ids.each do |item|
      new_relations << CardUser.new(user_id: item, card_id: params[:card_id])
    end
    if CardUser.import new_relations
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".fail"
    end
    respond_to :js
  end

  def edit
    respond_to :js
  end

  def destroy
    if @relation.destroy
      flash.now[:warning] = t ".success"
    else
      flash.now[:danger] = t ".fail"
    end
    respond_to :js
  end

  private

  def find_board
    @board = Board.find params[:board_id]
  end

  def find_relation
    @relation = CardUser.find_by card_id: params[:card_id],
                                user_id: params[:user_id]
    return if @relation

    flash.now[:danger] = t ".cant_delete"
    redirect_to root_path
  end

  def find_card
    @edited_card = Card.find params[:card_id]
    @card_users = @edited_card.users
  end
end
