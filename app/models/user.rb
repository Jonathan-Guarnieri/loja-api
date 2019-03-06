class User < ApplicationRecord  
  
  devise :database_authenticatable, :registerable
  include DeviseTokenAuth::Concerns::User

  enum role: [:seller, :manager]
  has_many :orders

  validates :name, presence: true
  validates :role, presence: true
  validates :email, presence: true
  
end
