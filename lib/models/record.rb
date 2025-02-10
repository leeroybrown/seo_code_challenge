# frozen_string_literal: true
require 'capitalize_names'
require_relative '../modules/validation'

class Record

  include Validation

  # Assumption: date of birth, passport number and national insurance number cannot be changed
  attr_reader :date_of_birth, :passport_number, :national_insurance_number
  attr_accessor :first_names, :last_name, :full_name, :address, :years_at_address, :errors

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

  def full_name
    "#{@first_names} #{@last_name}"
  end

  def output_values
    @passport_number.upcase! unless @passport_number.nil?
    @address = "#{@address[:line1]}, #{@address[:postcode]}" unless @address.nil?
    @errors = nil if @errors.empty?

    [CapitalizeNames.capitalize(@first_names),
     surname_format(surname: @last_name),
     @date_of_birth.strftime('%d, %b, %Y'),
     @address,
     @years_at_address,
     @passport_number,
     @national_insurance_number,
     @errors]
  end

  private

  def surname_format(surname:)
    if surname.chars.include?("'")
      surname.split("'").map(&:capitalize).join("'")
    else
      surname.capitalize
    end
  end
end
