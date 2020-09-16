class StaticPagesController < ApplicationController
  include SessionsHelper

  def home
    return if logged_in?

    flash[:warning] = t ".loginwarning"
    redirect_to login_path
  end
end
