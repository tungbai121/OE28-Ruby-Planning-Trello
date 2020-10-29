class SortableTagsController < ApplicationController
  before_action :load_board, :check_permission, only: :update

  def update
    tag_ids = params[:tag]
    list_id = params[:list][0]
    return unless tag_ids.present? && list_id.present?

    tag_ids.each_with_index do |id, index|
      Tag.update id, position: index, list_id: list_id
    end
  end

  private

  def load_board
    @board = Board.find params[:board_id]
  end
end
