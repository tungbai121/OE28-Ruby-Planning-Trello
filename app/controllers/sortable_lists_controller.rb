class SortableListsController < ApplicationController
  before_action :find_board, :check_permission, only: :update

  def update
    list_ids = params[:list]
    return if list_ids.blank?

    list_ids.each_with_index do |id, index|
      List.update id, position: index
    end
  end

  private

  def find_board
    @board = Board.find params[:board_id]
  end
end
