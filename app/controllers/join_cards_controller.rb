class JoinCardsController < ApplicationController
  before_action :load_data, :check_permission, only: %i(create destroy)

  def create
    if @card.users.include? current_user
      flash[:danger] = t ".user_in_card"
    elsif @card.users.push current_user
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".failed"
    end
    redirect_to @board
  end

  def destroy
    if @card.users.exclude? current_user
      flash[:danger] = t ".user_not_in_card"
    elsif @card.users.delete current_user
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".failed"
    end
    redirect_to @board
  end

  private

  def load_data
    @board = Board.find params[:board_id]
    @card = Card.find params[:id]
  end
end
