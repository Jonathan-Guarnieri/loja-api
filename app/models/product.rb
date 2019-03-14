class Product < ApplicationRecord

  has_many :order_item

  validates :name, presence: true
  validates :purchase_price, presence: true
  validates :sale_price, presence: true
  validates :amount, presence: true
  validate :amount_validation

  private
  
  def amount_validation
    raise "amount can not be negative" if amount.negative?
  end

end
