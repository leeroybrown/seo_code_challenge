# frozen_string_literal: true

require_relative '../modules/validation'

class Record

  include Validation

  # Assumption: date of birth, passport number and national insurance number cannot change
  attr_reader :date_of_birth, :passport_number, :national_insurance_number
  attr_accessor :first_names, :last_name, :full_name, :address, :years_at_address, :errors

  def initialize(first_names:, last_name:, date_of_birth:, years_at_address:, **other_fields)
    @first_names = first_names
    @last_name = last_name
    @date_of_birth = date_of_birth
    @years_at_address = years_at_address
    @full_name = "#{@first_names} #{@last_name}"
    @address = other_fields[:address]
    @passport_number = other_fields[:passport_number]
    @national_insurance_number = other_fields[:national_insurance_number]
    @errors = {}
  end

end
