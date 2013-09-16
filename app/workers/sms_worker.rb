require "globe_labs"

class SmsWorker
  include Sidekiq::Worker
  
  def perform(msg)
    sms = ShortMessage.new
    sms.target = msg["mobile_no"]
    sms.content = msg["message"]
    client = GlobeLabs.new
    resp = client.send_sms(short_message)
    Rails.logger.info("=== savon client resp: #{resp.inspect}")
  end
end
