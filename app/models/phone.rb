class Phone < ApplicationRecord
  belongs_to :contact, optional: true # Lucas / sem optional -> Validation failed: Contact must exist

  validates :number, presence: true
  validate :phone_number_validation

  private # pq usar o private?

  def phone_number_validation
    # aceita telefones brasileiros formatados com ou sem parenteses no DDD e com ou sem hífen entre números
    phone_number_is_valid = number.to_s.gsub(' ', '') =~ /[(]?[0]?[1-9][1-9][)]?[-]?([9][-]?[6-9][0-9]{3}|[2-5][0-9]{3})[-]?[0-9]{4}/ ? true : false
    raise 'phone number is invalid' unless phone_number_is_valid
  end
end
