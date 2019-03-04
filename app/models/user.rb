class User < ActiveRecord::Base
  # Carrierwave image uploading
  mount_uploader :profile_picture, ProfilePictureUploader
  process_in_background :profile_picture
  store_in_background :profile_picture

  # Save emails as downcase to the db
  before_save { self.email = email.downcase }

  # Email validation regex
  REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # Validations
  validates :name, uniqueness: true, presence: true, length: {maximum: 50}
  validates :email, uniqueness: true, presence: true,  length: {maximum: 150}, format: { with: REGEX } 
  validates :password_digest, presence: true,length: { minimum: 6 }

  # Adds virtual attributes password & password_confirmation to User and saves them as password_digest using BCrypt
  has_secure_password

  # Returns hash digest of given string using BCrypt
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Relationships
  has_many :projects
  has_many :articles
end
