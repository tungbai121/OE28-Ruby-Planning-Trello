class StaticPagesController < ApplicationController
  before_action :user_board

  def home
    redirect_to new_user_session_path unless user_signed_in?
  end
end
