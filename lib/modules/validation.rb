# frozen_string_literal: true

module Validation

  def character_limit_exceeded?(name:)
    # Assumption: whitespaces are included in character count
    name.length > 45
  end

  def characters_valid?(name:)
    # Assumption: Permitted special characters not allowed at the start or end of the first / last names string
    name.match?(/^[a-zA-Z](?:[ '.\-a-zA-Z]*[a-zA-Z])?$/)
  end

  def check_age(date_of_birth:)
    # Assumption: age is calculated from the date application is run
    date_today = Date.today
    age = date_today.year - date_of_birth.year
    age -= 1 if date_today.yday < date_of_birth.yday
    age
  end

  def check_address(address:)
    # Assumption: address is invalid if postcode is NOT present or address is nil
    return false if address.nil?
    return false unless address.key?(:postcode)
  end

  def check_years_at_address(record:)
    return false if years_at_address.nil?

    record.years_at_address >= 5
  end

  def check_identity_numbers(record:)
    false if record.passport_number.nil? && record.national_insurance_number.nil?
  end

end
