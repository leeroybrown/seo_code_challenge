# frozen_string_literal: true

module Validation
  # define error classes
  class ExceededCharacterLimitError < StandardError; end

  class InvalidCharacterError < StandardError; end

  class MinimumAgeError < StandardError; end

  class InvalidAddressError < StandardError; end

  class LivedAtAddressError < StandardError; end

  def check_character_limit(name:)
    # Assumption: whitespaces are included in character count
    raise ExceededCharacterLimitError, "Name cannot exceed 45 characters: #{name}" if name.length > 45
  end

  # TODO: This method isn't working as expected, need to fix
  def check_character_validity?(name:)
    return if name.match?(/(?=\S*['-])([a-zA-Z'-]+)/)

    raise InvalidCharacterError, "Name contains invalid characters: #{name}"

  end

  def check_age(date_of_birth:)
    # Assumption: age is calculated from the date application is run
    date_today = Date.today
    age = date_today.year - date_of_birth.year
    age -= 1 if date_today.yday < date_of_birth.yday
  end

end
