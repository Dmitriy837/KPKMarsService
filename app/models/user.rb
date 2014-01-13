class PaswordChoosenValidator < ActiveModel::Validator
  def validate(record)
    if record.password_hash == "" || record.password_salt == "" || !record.password_hash || !record.password_salt
      record.errors[:password] << " can't be blank"
    end
  end
end

class User < ActiveRecord::Base
  has_many :firms
  validates :login, :presence => true
  validates_uniqueness_of :login
  validates_with PaswordChoosenValidator
  
 def self.authenticate(login, password)
    user = User.find_by(login: login)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password(password)
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    else
      self.password_salt = nil
      self.password_hash = nil
    end
  end
end
