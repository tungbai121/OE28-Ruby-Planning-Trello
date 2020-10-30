class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params
  before_action :configure_account_update_params,
                :correct_user, only: :update

  def update
    if update_resource resource, account_update_params
      bypass_sign_in current_user
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit :sign_up, keys: [:name, :email]
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit :account_update, keys: User::USER_PARAMS
  end

  def after_inactive_sign_up_path_for resource
    new_confirmation_path resource
  end

  def correct_user
    redirect_to resource unless current_user? resource
  end

  def update_resource resource, params
    resource.update_without_password params
  end
end
