# frozen_string_literal: true

require_relative 'record'

class RecordProcessor
  # Creates a NoRecordsError error object
  # Parent [StandardError]
  class NoRecordsError < StandardError; end

  # Assumption: file_path, valid_records and invalid_records do not change
  attr_reader :file_path, :valid_records, :invalid_records

  # Creates a RecordProcessor object to process records
  # @param file_path [String], valid_records [Set], invalid_records [Set]
  # @return [RecordProcessor]

  def initialize(file_path:)
    @file_path = file_path
    @valid_records = Set.new
    @invalid_records = Set.new
  end

  # Processes records
  # @return [Hash] of valid and invalid records

  def process
    parsed_data = parse_xml_file
    process_records(data: parsed_data)
    {
      valid: @valid_records,
      invalid: @invalid_records
    }
  end

  private

  # Parse XML file
  # @return [Hash]

  def parse_xml_file
    xml_document = Nokogiri::XML(File.open(@file_path)).to_s
    parser = Nori.new(convert_tags_to: ->(h) { SimpleSymbolize.symbolize(h) })
    parser.parse(xml_document)
  end

  # Processes the returned hash from parse_xml_file
  # @param data [Hash]
  # @return [RecordProcessor]

  def process_records(data:)
    records = data.dig(:data, :people)
    raise NoRecordsError, 'No records found' unless records

    records.each do |record_data|
      record = Record.new(**record_data)
      validate_record(record: record)
    end
  end

  # Sorts records into valid and invalid
  # @param record
  # @return [RecordProcessor]

  def validate_record(record:)
    if valid_record?(record: record)
      @valid_records << record.output_values
    else
      @invalid_records << record.output_values
    end
  end

  # Determines valid and invalid records
  # @param record [Hash]
  # @return [Boolean]

  def valid_record?(record:)
    valid_name_characters?(record: record)
    valid_name_length?(record: record, attribute: :first_names)
    valid_name_length?(record: record, attribute: :last_name)
    valid_age?(record: record)
    valid_address?(record: record)
    valid_years_at_address?(record: record)
    valid_identity_numbers?(record: record)

    return false if !valid_name_characters?(record: record) ||
                    !valid_age?(record: record) ||
                    !valid_name_length?(record: record, attribute: :first_names) ||
                    !valid_name_length?(record: record, attribute: :last_name) ||
                    !valid_years_at_address?(record: record) ||
                    !valid_identity_numbers?(record: record) ||
                    !valid_address?(record: record)

    true
  end

  # Determines if length of a string exceeds limit
  # @param record [Record], attribute [Symbol]
  # @return [Boolean]

  def valid_name_length?(record:, attribute:)
    name = record.send(attribute)

    if record.character_limit_exceeded?(name: name)
      record.errors[:character_limit] = "Character limit exceeded: #{name.length}"
      false
    end

    true
  end

  # Determines if a string contains invalid characters
  # @param record [Record]
  # @return [Boolean]

  def valid_name_characters?(record:)
    name = record.full_name

    if record.characters_valid?(name: name) == false
      record.errors[:invalid_character] = 'Name contains invalid characters'
      return false
    end

    true
  end

  # Determines if age is valid
  # @param record [Record]
  # @return [Boolean]

  def valid_age?(record:)
    if record.check_age(date_of_birth: record.date_of_birth) < 18
      record.errors[:minimum_age] = "Minimum age not met: #{record.check_age(date_of_birth: record.date_of_birth)}"
      return false
    end

    true
  end

  # Determines if years_at_address is greater than 5
  # @param record [Record]
  # @return [Boolean]

  def valid_years_at_address?(record:)
    if record.years_at_address_valid?(years_at_address: record.years_at_address) == false
      record.errors[:years_at_address] = "Years at address not met: #{record.years_at_address}"
      return false
    end

    true
  end

  # Determines if identity numbers are valid
  # @param record [Record]
  # @return [Boolean]

  def valid_identity_numbers?(record:)
    if record.identity_numbers_valid?(passport_number: record.passport_number,
                                      national_insurance_number: record.national_insurance_number) == false
      record.errors[:identity_numbers] = 'Missing both identity numbers'
      return false
    end

    true
  end

  # Determines if address is valid
  # @param record [Record]
  # @return [Boolean]

  def valid_address?(record:)
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
