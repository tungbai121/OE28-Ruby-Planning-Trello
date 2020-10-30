class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Google"
    sign_in_and_redirect User.from_omniauth request.env["omniauth.auth"]
  end
end
