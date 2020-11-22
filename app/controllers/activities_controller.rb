class ActivitiesController < ApplicationController
  before_action :find_user, only: %i(index)

  def index
    @activities = current_user.activities.order_by_created_at
  end

  private

  def find_user
    @user = User.find params[:user_id]
  end
end
