class User < ActiveRecord::Base
  #extend FriendlyId
  #friendly_id :username, :use => :slugged
  validates_format_of :username, :with => /\A[a-z0-9]+\z/i
  validates_format_of :mobile_no, :with => /\A[0-9]+\z/i

  has_many :authorizations

  def self.create_from_omniauth!(hash)
    info = hash['info']
    create! do |user|
      user.username = info['name']
      user.email = info['email']
      user.firstname = info['first_name']
      user.lastname = info['last_name']
    end
  end

  def self.create_from_params!(hash)
    user = User.where(:mobile_no => hash["mobile_no"]).first

    unless user
      user = User.new
      user.mobile_no = hash["mobile_no"]
      user.username = hash["mobile_no"]
      user.save
    end

    user
  end
end
