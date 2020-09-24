class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_locale

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def user_board
    opened_board = Board.opened
    @favorite_boards = opened_board.favorite current_user.id
    @my_boards = opened_board.nonfavorite current_user.id
  end

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end
end
