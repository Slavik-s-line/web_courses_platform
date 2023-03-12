class ApplicationController < ActionController::Base
  after_action :user_activity
  before_action :authenticate_user!
  before_action :set_global_variables, if: :user_signed_in?

  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  include PublicActivity::StoreController #save current_user using gem public_activity

  include Pagy::Backend

  def set_global_variables
    @ransack_courses = Course.ransack(params[:courses_search], search_key: :courses_search) #navbar search
  end

  private

  def user_activity
    current_user.try :touch
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end
end
