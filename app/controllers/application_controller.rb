class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_locale, :authenticate_user!, :user_board, :search_data

  def self.default_url_options options = {}
    options.merge locale: I18n.locale
  end

  private

  def rescue_404_exception
    render file: Rails.root.join("public", "404.html").to_s, layout: false,
           status: :not_found
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def user_board
    return unless current_user

    @starred_boards = Board.of_user(current_user.id).opened.starred
    @my_boards = Board.of_user(current_user.id)
  end

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end

  def load_activities
    @activities = @board.activities.order_by_created_at
  end

  def check_permission
    permission = UserBoard.find_by user_id: current_user.id, board_id: @board.id
    if permission
      return if permission.leader? || permission.member?

      flash[:danger] = t ".permission_denied"
    else
      flash[:danger] = t ".user_not_in_board"
    end
    redirect_to @board
  end

  def search_data
    @search = Board.includes(:users).ransack params[:q]
  end
end
