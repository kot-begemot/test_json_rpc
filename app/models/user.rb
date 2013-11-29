class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :trackable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  # You likely have this before callback set up for the token.
  before_save :ensure_authentication_token

  # Delete default password length validator. The one provided by devise 
  _validators[:password].delete_if do |v| 
    v.class == ActiveModel::Validations::LengthValidator
  end

  validates :password, :format => { 
    :with => /\A.*(?=.*[a-zA-Z])(?=.*\d).*\Z/i, 
    message: "Password should contain at least one digit and one letter"},
    :length => { :maximum => 5 }
  
  # Yes, as simple as that. Another way would be regenerate this token
  # after a time
  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end
 
  private
  
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
