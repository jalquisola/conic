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
      redirect_to signin_path, :notice => "Login First!"
    end

    if current_user.id != params[:id].to_i
      @current_user = nil
      session[:user_id] = nil
      redirect_to signin_path, :notice => "Login First!"
    end
  end
end
