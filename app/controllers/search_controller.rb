class SearchController < ApplicationController
  def index
    @boards = Board.by_name(params[:search]).by_status true
  end
end
