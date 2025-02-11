# frozen_string_literal: true

require_relative 'record'

class RecordProcessor

  class NoRecordsError < StandardError; end

  attr_reader :file_path, :valid_records, :invalid_records, :summarise_invalid_records, :summarise_valid_records

  def initialize(file_path:)
    @file_path = file_path
    @valid_records = Set.new
    @invalid_records = Set.new
    @summarise_valid_records = Set.new
    @summarise_invalid_records = Set.new
  end

  def process
    parsed_data = parse_xml_file
    process_records(data: parsed_data)
    {
      valid: @valid_records,
      invalid: @invalid_records
    }
  end

  private

  def parse_xml_file
    xml_document = Nokogiri::XML(File.open(@file_path)).to_s
    parser = Nori.new(convert_tags_to: ->(h) { SimpleSymbolize.symbolize(h) })
    parser.parse(xml_document)
  end

  def process_records(data:)
    records = data.dig(:data, :people)
    raise NoRecordsError, 'No records found' unless records

    records.each do |record_data|
      record = Record.new(**record_data)
      validate_record(record: record)
    end
  end

  def validate_record(record:)
    if valid_record?(record)
      @valid_records << record.output_values
    else
      @invalid_records << record.output_values
    end
  end

  # TODO: named argument
  def valid_record?(record)
    validate_name_characters(record)
    validate_name_length(record, :first_names)
    validate_name_length(record, :last_name)
    validate_age(record: record)
    validate_address(record: record)
    validate_years_at_address(record: record)
    validate_identity_numbers(record: record)

    return false if validate_name_characters(record) ||
      validate_name_length(record, :first_names) ||
      validate_name_length(record, :last_name) ||
      validate_age(record: record) ||
      !validate_years_at_address(record: record) ||
      !validate_identity_numbers(record: record) ||
      !validate_address(record: record)

    true
  end

  # TODO: named argument
  def validate_name_length(record, attribute)
    name = record.send(attribute)

    if record.character_limit_exceeded?(name: name)
      record.errors[:character_limit] = "Character limit exceeded: #{name.length}"
      true
    end

    false
  end

  # TODO: named argument
  def validate_name_characters(record)
    name = record.full_name

    return if record.characters_valid?(name: name)

    record.errors[:invalid_character] = 'Name contains invalid characters'
    true

  end

  def validate_age(record:)
    return unless record.check_age(date_of_birth: record.date_of_birth) < 18

    record.errors[:minimum_age] = "Minimum age not met: #{record.check_age(date_of_birth: record.date_of_birth)}"
    true

  end

  def validate_years_at_address(record:)
    if record.years_at_address_valid?(years_at_address: record.years_at_address) == false
      record.errors[:years_at_address] = "Years at address not met: #{record.years_at_address}"
      return false
    end

    true
  end

  def validate_identity_numbers(record:)
    if record.identity_numbers_valid?(passport_number: record.passport_number, national_insurance_number: record.national_insurance_number) == false
      record.errors[:identity_numbers] = 'Missing both identity numbers'
      return false
    end

    true
  end

  def validate_address(record:)
    # Can I use pattern matching here?
    if record.address_valid?(address: record.address) == false
      record.errors[:invalid_address] = 'Invalid address'
      return false
    end

    if record.address.key?(:line1) == false
      record.address = {
        line1: "#{record.address[:building_number]} #{record.address[:street_name]} #{record.address[:town]}",
        postcode: record.address[:postcode]
      }
    end
    true
  end
end
