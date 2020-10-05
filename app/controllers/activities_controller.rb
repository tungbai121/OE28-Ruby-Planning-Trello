class ActivitiesController < ApplicationController
  before_action :load_user, only: %i(index)

  def index
    @activities = current_user.notifications.order_created
  end

  private

  def load_user
    @user = User.find params[:user_id]
  end
end
