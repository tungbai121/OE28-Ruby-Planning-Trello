class SearchController < ApplicationController
  def index
    @boards = @search.result(distinct: true).by_status true
  end
end
