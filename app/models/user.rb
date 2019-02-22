class User < ApplicationRecord
  enum role: [:seller, :manager]

  validates :name, presence: true
  validates :role, presence: true
  validates :login, presence: true
  validates :password, presence: true

end
