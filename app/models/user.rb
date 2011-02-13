require 'digest'
class User < ActiveRecord::Base
  
  # virual password attribute. This mean this attribute doesn't exist in the database but only in memory
  attr_accessor :password
  
  # public class memebers (accesible)
  attr_accessible :name, :email, :password, :password_confirmation
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  # validate that there's a name and email entered
  validates :name, :presence => true,
  				   :length   => { :maximum => 50 }
  validates :email, :presence => true,
 					:format   => { :with => email_regex },
 					:uniqueness => { :case_sensitive => false }
  
  # Automatically create the virtual attribute 'password_confirmation'.
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }
  
  # encrypt the password before saving the user to the Database
  before_save :encrypt_password
  
  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    # Compare encrypted_password with the encrypted version of
    # submitted_password.
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  private

    def encrypt_password
    							#new_record? checks if the user already saved to the DB or not. We don't want to change the unique salt used to hash the password everytime the user is updated
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
      
end
