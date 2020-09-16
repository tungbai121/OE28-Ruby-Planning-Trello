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
    @favorite_boards = Board.favorite current_user.id
    @my_boards = Board.nonfavorite current_user.id
  end
end
