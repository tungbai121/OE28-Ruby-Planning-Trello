class StaticPagesController < ApplicationController
  before_action :logged_in_user
  before_action :user_board

  def home
    redirect_to login_path unless logged_in?
  end
end
