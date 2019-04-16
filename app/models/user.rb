class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :username, presence: true, uniqueness: true

  has_many :widgets

  def self.can_sign_in(email, password)
    user = User.find_by(email: email)
    return unless user

    user if user.valid_password?(password)
  end
end
