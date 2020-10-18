class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me, :profile, :image]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def after_sign_in_path_for(resource)
    missions_path
  end

  def check_guest
  email = email || params[:user][:email].downcase
    if  current_user.email == 'guest@example.com'
      redirect_to missions_path, alert: 'ゲストユーザーの変更・削除はできません。'
    end
  end
  

end
