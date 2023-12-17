class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: "You are not authorized to access this page."
  end

  rescue_from ActionController::InvalidAuthenticityToken, with: :handle_unauthenticated_access

  private

  def handle_unauthenticated_access
    # Redirect to the login page or do something else
    redirect_to new_user_session_path, alert: 'You need to sign in to access this page.'
  end
end
