class ApplicationController < ActionController::Base
  protect_from_forgery

  respond_to :html, :json
  responders :flash, :http_cache

  check_authorization :unless => :devise_controller?
  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in?
      redirect_to todolists_path, alert: t("flash.cancan.denied.alert")
    else
      redirect_to root_url, alert: t("flash.cancan.denied.not_signed_in.alert")
    end
  end

  def after_sign_in_path_for(resource)
    todolists_path
  end
end
