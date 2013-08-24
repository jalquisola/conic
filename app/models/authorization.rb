class Authorization < ActiveRecord::Base
  attr_accessible :provider, :uid, :user_id

  belongs_to :user
  validates_presence_of :user_id, :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_from_omniauth(hash)
    find_by_provider_and_uid(hash['provider'], hash['uid'])
  end

  def self.create_from_omniauth(hash, user = nil)
    user ||= User.create_from_omniauth!(hash)

    credentials = hash['credentials']
    info = hash['info']
    provider = hash['provider']
    Authorization.create! do |authorization|
      authorization.user = user
      authorization.uid = hash['uid']
      authorization.provider = provider
      authorization.token = credentials['token']
      authorization.secret = credentials['secret']
      authorization.image = info['image']
      authorization.link = info['urls'][provider.titleize]
    end
  end
end
