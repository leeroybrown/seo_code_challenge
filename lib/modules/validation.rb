# frozen_string_literal: true

module Validation
  # Determines if length of a string exceeds character limit
  # @param name [String]
  # @return [Boolean]

  def character_limit_exceeded?(name:)
    # Assumption: whitespaces are included in character count
    name.length > 45
  end

  # Determines if characters of a string are valid
  # @param name [String]
  # @return [Boolean]

  def characters_valid?(name:)
    # Assumption: Permitted special characters not allowed at the start or end of the first / last names string
    name.match?(/^[a-zA-Z](?:[ '.\-a-zA-Z]*[a-zA-Z])?$/)
  end

  # Determines current age
  # @param date_of_birth [Date]
  # @return [Integer]

  def check_age(date_of_birth:)
    # Assumption: age is calculated from the date application is run
    date_today = Date.today
    age = date_today.year - date_of_birth.year
    age -= 1 if date_today.yday < date_of_birth.yday
    age
  end

  # Determines if address is valid
  # @param address [Hash]
  # @return [Boolean]

  def address_valid?(address:)
    # Assumption: address is invalid if postcode is NOT present or address is nil
    return false if address.nil? || address.empty?
    return false unless address.key?(:postcode)

    true
  end

  # Determines if years_at_address exceeds 5
  # @param years_at_address [Integer]
  # @return [Boolean]

  def years_at_address_valid?(years_at_address:)
    return false unless years_at_address.is_a?(Integer)
    return false if years_at_address.negative?
    return false if years_at_address.nil?

    years_at_address >= 5
  end

  # Determines if identity numbers are valid
  # @param passport_number [String], national_insurance_number [String]
  # @return [Boolean]

  def identity_numbers_valid?(passport_number:, national_insurance_number:)
    return false if passport_number.nil? && national_insurance_number.nil?

    true
  end
end
