class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |member|
      member.email = auth.info.email
      member.name = auth.info.name
      member.password = Devise.friendly_token[0,20]
    end
  end
  
  def self.find_for_facebook_oauth(auth, signed_in_resource = nil)
      member = Member.where(provider: auth.provider, uid: auth.uid).first
      if member.present?
          member
      else
          member = Member.create(
  
                                                 provider:auth.provider,
                                                 uid:auth.uid,
                                                 email:auth.info.email,
                                                 password:Devise.friendly_token[0,20])
      end
  end

  def largeimage
    "http://graph.facebook.com/#{self.uid}/picture?type=large"
  end
  def normalimage
    "http://graph.facebook.com/#{self.uid}/picture?type=normal"
  end
  def smallimage
    "http://graph.facebook.com/#{self.uid}/picture?type=small" 
  end
  
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url => "/images/:style/default.jpg"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end


#LINK DO STACK : https://stackoverflow.com/questions/18480301/if-user-persisted-with-facebook-omniauth-devise