class SearchController < ApplicationController
  before_action :user_board

  def index
    @boards = @search.result(distinct: true).by_status true
  end
end
