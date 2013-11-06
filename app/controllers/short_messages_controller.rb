require "will_paginate"
class ShortMessagesController < ApplicationController
  before_action :set_short_message, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:index, :show, :edit, :update, :destroy]

  # GET /short_messages
  # GET /short_messages.json
  def index
    @short_messages = ShortMessage.order("created_at DESC").paginate(:page => params[:page], :per_page => 2)
    cell_nos = []
    @short_messages.each do |sms|
      cell_nos << sms.target
      cell_nos << sms.source
    end

    @users = User.where(:mobile_no => cell_nos).index_by(&:mobile_no)
  end

  # GET /short_messages/1
  # GET /short_messages/1.json
  def show
  end

  # GET /short_messages/new
  def new
    @short_message = ShortMessage.new
  end

  # GET /short_messages/1/edit
  def edit
  end

  # POST /short_messages
  # POST /short_messages.json
  def create
    @short_message = ShortMessage.new(short_message_params)

    respond_to do |format|
      if @short_message.save
        client = GlobeLabs.new
        resp = client.send_sms(@short_message)
        Rails.logger.info("=== savon client resp: #{resp.inspect}")

        format.html { redirect_to @short_message, notice: 'Short message was successfully created.' }
        format.json { render action: 'show', status: :created, location: @short_message }
      else
        format.html { render action: 'new' }
        format.json { render json: @short_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /short_messages/1
  # PATCH/PUT /short_messages/1.json
  def update
    respond_to do |format|
      if @short_message.update(short_message_params)
        format.html { redirect_to @short_message, notice: 'Short message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @short_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /short_messages/1
  # DELETE /short_messages/1.json
  def destroy
    @short_message.destroy
    respond_to do |format|
      format.html { redirect_to short_messages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_short_message
      @short_message = ShortMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def short_message_params
      params[:short_message].permit(:target, :content)
    end
end
