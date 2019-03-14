class Order < ApplicationRecord
  
  enum order_type: [:purchase, :sale]
  enum status: [:budget, :production, :delivered, :canceled]
  belongs_to :contact
  belongs_to :user
  has_many :order_item
  
  accepts_nested_attributes_for :order_item, allow_destroy: true

  validates :order_type, presence: true
  validates :status, presence: true
  
end
