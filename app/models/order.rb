class Order < ApplicationRecord
  
  enum order_type: [:purchase, :sale]
  enum status: [:budget, :production, :delivered, :canceled]
  belongs_to :contact
  belongs_to :user

  validates :order_type, presence: true
  validates :contact_id, presence: true
  validates :user_id, presence: true
  validates :status, presence: true
  
end
