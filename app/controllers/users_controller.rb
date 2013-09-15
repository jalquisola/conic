class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:edit, :update, :show]

  def edit
    @user = current_user
    @authorizations = @user.authorizations.select("provider").map(&:provider)
  end

  def create
    @user = User.create_from_params!(params[:user])
    #self.current_user = @user
    session[:mobile_no] = params[:user][:mobile_no]

    send_verification_code

    redirect_to verify_path(@user.mobile_no)
    #redirect_to edit_user_path(@user)
  end

  def verify
    @user = User.find(params[:id])
    if @user.verification_code.to_s == params[:user][:verification_code]
      self.current_user = @user
      redirect_to edit_user_path(@user)
    else
      send_verification_code
      redirect_to verify_path(@user.mobile_no), :notice => "Invalid Code."
    end
  end

  def show
    @user = User.find(params[:id])
    @authorizations = @user.authorizations.select("provider").map(&:provider)
  end

  def update
    @user = User.find(params[:id])
    user = params[:user]
    @user.username = user["username"]
    @user.email = user["email"]
    @user.mobile_no = user["mobile_no"]

    respond_to do |format|
      if @user.save!
        format.html { redirect_to @user, notice: 'Profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def send_verification_code
    code = rand(1000)
    @user.verification_code = code
    @user.save
    Rails.logger.info("code: #{code}")
    msg = SmsGenerator.verify_code(code)
    SmsWorker.perform_async({:message => msg, :mobile_no => @user.mobile_no})
  end

end
