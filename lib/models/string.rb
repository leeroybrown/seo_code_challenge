# frozen_string_literal: true

require 'capitalize_names'

class String
  # Monkey patching the Sting class to add methods
  # @return [String]

  # Use CaptializeNames gem to correctly format first_names
  # @param [self]
  # @return [String]
  def capitalize_first_names
    CapitalizeNames.capitalize(self)
  end

  # Correctly formats surname to capitalize first and all letters following an apostrophe
  # @param record [self]
  # @return [String]

  def capitalize_surname
    if chars.include?("'")
      split("'").map(&:capitalize).join("'")
    else
      capitalize
    end
  end
end
