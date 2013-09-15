class SmsController < ActionController::Base
  #protect_from_forgery with: :null_session
  skip_before_filter :verify_authenticity_token

  def receive
    Rails.logger.info("sms#recieve params: #{params.inspect}")
    request_body = request.body.read

    body = Hash.from_xml(request_body)["message"]["param"].inject({}) do |result, elem| 
         result[elem["name"]] = elem["value"] 
         result 
        end

    Rails.logger.info("sms#recieve to_xml: #{body.inspect}")

    @short_message = ShortMessage.new
    @short_message.source = body["source"]
    @short_message.target = body["target"]
    @short_message.content = body["msg"]
    @short_message.msg_type = body["messageType"]
    @short_message.uid = body["uid"]
    @short_message.udh = body["udh"]
    @short_message.save

    render :json => {}, :status => :ok
  end
end
