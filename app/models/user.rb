class User < ApplicationRecord
  has_secure_password

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true

  def self.authenticate_with_credentials(email, password)
    email.strip!  # Remove leading/trailing spaces
    email.downcase!  # Convert to lowercase
    user = User.find_by(email: email)
    user && user.authenticate(password)
  end
end
