# frozen_string_literal: true

require_relative 'string'
require_relative '../modules/validation'


class Record

  # mix-in Validation methods
  include Validation

  # Assumption: date of birth, passport number and national insurance number cannot be changed
  attr_reader :date_of_birth, :passport_number, :national_insurance_number
  attr_accessor :first_names, :last_name, :full_name, :address, :years_at_address, :errors

  # Create a record object
  # @params first_names [String], last_name [String], date_of_birth [Date], years_at_address [String], **other_fields [Hash]
  # @return [Record] with attributes

  def initialize(first_names:, last_name:, date_of_birth:, years_at_address:, **other_fields)
    @first_names = first_names
    @last_name = last_name
    @date_of_birth = date_of_birth
    @address = other_fields[:address]
    @years_at_address = years_at_address
    @passport_number = other_fields[:passport_number]
    @national_insurance_number = other_fields[:national_insurance_number]
    @errors = {}
  end

  # Concatenates first_names and last_name to create a full_name
  # @return [String]
  def full_name
    "#{@first_names} #{@last_name}"
  end

  # Creates an array of values to write to file
  # @return [Array]
  def output_values
    @passport_number.upcase! unless @passport_number.nil?

    [@first_names.capitalize_first_names,
     @last_name.capitalize_surname,
     @date_of_birth.strftime('%d, %b, %Y'),
     @address,
     @years_at_address,
     @passport_number,
     @national_insurance_number,
     @errors]
  end
end
