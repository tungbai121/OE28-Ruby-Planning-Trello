class SessionsController < ApplicationController
  layout false

  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      log_in user
      redirect_back_or root_url
    else
      flash.now[:danger] = t ".error"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    flash[:primary] = t ".logout"
    redirect_to root_url
  end
end
