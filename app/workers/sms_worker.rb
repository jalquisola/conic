class SmsWorker
  include Sidekiq::Worker
  
  def perform(msg)
  end
end
