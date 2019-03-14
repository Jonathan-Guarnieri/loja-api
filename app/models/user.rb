class User < ApplicationRecord  
  
  devise :database_authenticatable, :registerable, :validatable
  include DeviseTokenAuth::Concerns::User

  enum role: [:seller, :manager]
  has_many :orders

  validates :name, presence: true
  validates :role, presence: true
  # Devise já por padrão valida o formato e presença do e-mail e a presença da password.
  # A validação de ambos (presença e formato, email e password) é configurável dentro de config/initializers/devise.rb,
  # porém essa configuração só funciona se o :validatable está declarado aqui no model.
  
end
