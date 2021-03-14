class ApplicationController < ActionController::Base
  include PublicActivity::StoreController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :configure_account_update_params, if: :devise_controller?
  # I18 locale
  before_action :switch_locale

  protected

  def switch_locale(&action)
    locale = current_user&.language&.code || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end

  def demo_mode
    sign_in User.demo_mode
  end
end
