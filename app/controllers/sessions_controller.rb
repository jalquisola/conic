class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    unless @auth = Authorization.find_from_omniauth(auth)
      @auth = Authorization.create_from_omniauth(auth, current_user)
    end

    self.current_user = @auth.user

    if current_user.email.blank? || current_user.mobile_no.blank?
      redirect_to edit_user_path(current_user)
    else
      redirect_to activities_path
    end
  end

  def new
    render :layout => "signin"
  end

  def destroy
    @current_user = nil
    session[:user_id] = nil
    redirect_to root_path
  end
end
