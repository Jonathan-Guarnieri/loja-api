class Product < ApplicationRecord

  validates :name, presence: true
  # validates :purchase_price, optional: true # "optional: true" neste caso não é default? tem que declarar?
  # validates :sale_price, optional: true
  validates :amount, presence: true
  validate :amount_validation

  private # pq usar o private?
  
  def amount_validation
    raise "amount can not be negative" if amount.negative?
  end

end
