class SessionsController < ApplicationController
  layout false

  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      log_in user
      redirect_to root_url
    else
      flash.now[:danger] = t ".error"
      render :new
    end
  end
end
