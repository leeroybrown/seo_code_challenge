# frozen_string_literal: true

require_relative '../modules/validation'

class Person

  include Validation

  attr_reader :date_of_birth, :passport_number, :national_insurance_number
  attr_accessor :first_names, :last_name, :address, :years_at_address, :errors

  def initialize(**opts)
    @first_names = opts[:first_names]
    @last_name = opts[:last_name]
    @address = opts[:address]
    @date_of_birth = opts[:date_of_birth]
    @passport_number = opts[:passport_number]
    @national_insurance_number = opts[:national_insurance_number]
    @years_at_address = opts[:years_at_address]
    @errors = {}
  end

end
