class PagesController < ApplicationController

  def home
  end

  def get_started
  end

  def register
    mobile_no = params[:mobile_no]
  end

  def verify
    @user = User.where(:mobile_no => params[:mobile_no]).first
  end
end
