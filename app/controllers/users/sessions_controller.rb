class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params

  skip_authorization_check

  protected

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end
end
