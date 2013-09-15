class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :signed_in?

 protected

  def current_user
    if @current_user.blank? && session[:user_id].present?
      @current_user = User.where(:id => session[:user_id]).first
    end

    @current_user
  end

  def signed_in?
    !!current_user
  end

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.id
  end

  def authenticate_user!
    Rails.logger.info("current_user: #{current_user.inspect}")
    if current_user.blank?
      redirect_to root_path, :notice => "Login First!"
      return
    end

    if ["short_messages"].include?(params[:controller]) && current_user.mobile_no != "97919534"
      redirect_to "/get_started", :notice => "You have no access to that page."
      return
    end

    if ["users"].include?(params[:controller]) && ["list"].include?(params[:action]) && current_user.mobile_no != "97919534"
      redirect_to "/get_started", :notice => "You have no access to that page."
      return
    end

    Rails.logger.info("=== #{params.inspect} ====")
    if params[:controller] == "users" && ["show", "update", "edit"].include?(params[:action]) && current_user.id != params[:id].to_i
      redirect_to user_path(current_user), :notice => "You have no access to that page."
      return
    end
  end

end
