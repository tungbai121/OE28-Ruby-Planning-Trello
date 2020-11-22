class SortableCardsController < ApplicationController
  before_action :find_board, :check_permission, only: :update

  def update
    card_ids = params[:card]
    list_id = params[:list][0]
    return if card_ids.blank? && list_id.blank?

    card_ids.each_with_index do |id, index|
      Card.update id, position: index, list_id: list_id
    end
  end

  private

  def find_board
    @board = Board.find params[:board_id]
  end
end
