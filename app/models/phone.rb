class Phone < ApplicationRecord
  belongs_to :contact, optional: true

  validates :number, presence: true
end
