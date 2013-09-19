class User < ActiveRecord::Base

  before_save do
    self.email = email.downcase
    self.username = username.downcase
  end

  has_secure_password

  has_many :photos, dependent: :destroy
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
end
