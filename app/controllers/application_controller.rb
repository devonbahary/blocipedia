class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :authenticate_user!
  
  def downgrade_membership
    flash[:alert] = "Your membership has been downgraded to standard."
    current_user.standard!
    redirect_to edit_user_registration_path
  end
end
