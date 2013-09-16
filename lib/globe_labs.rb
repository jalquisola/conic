class GlobeLabs
  def initialize
    @client = Savon.client(wsdl: GLOBE_LABS_CONFIG["wsdl"], :endpoint => GLOBE_LABS_CONFIG["endpoint"])
  end

  def send_sms(short_message)
    @client.call(:send_sms, :message => {"uName" => GLOBE_LABS_CONFIG["uName"],
                                         "uPin" => GLOBE_LABS_CONFIG["uPin"],
                                         "MSISDN" => short_message.target,
                                         "messageString" => short_message.content,
                                         "Display" => 1, "udh" => "", "mwi" => "", "coding" => 0}) 
  end
end
