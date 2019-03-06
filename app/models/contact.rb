class Contact < ApplicationRecord
  enum kind: [:client, :supplier]

  has_many :phones
  has_many :orders

  validates :name, presence: true
  validates :address, presence: true
  validate :document_validation
  validates :kind, presence: true

  accepts_nested_attributes_for :phones

  def document_validation
    errors.add(:document) unless ( CPF.valid?(document) || CNPJ.valid?(document) )
  end

end
