# frozen_string_literal: true

require_relative 'record'

class RecordProcessor
  class NoRecordsError < StandardError; end

  def initialize(file_path:)
    @file_path = file_path
    @valid_records = Set.new
    @invalid_records = Set.new
  end

  def process
    parsed_data = parse_xml_file
    process_records(parsed_data)
    { valid: @valid_records, invalid: @invalid_records }
  end

  private

  def parse_xml_file
    xml_document = Nokogiri::XML(File.open(@file_path)).to_s
    parser = Nori.new(convert_tags_to: ->(h) { SimpleSymbolize.symbolize(h) })
    parser.parse(xml_document)
  end

  def process_records(data)
    records = data.dig(:data, :people)
    raise NoRecordsError, 'No records found' unless records

    records.each do |record_data|
      record = Record.new(**record_data)
      validate_record(record)
    end
  end

  def validate_record(record)
    if valid_record?(record)
      @valid_records << record
    else
      @invalid_records << record
    end
  end

  def valid_record?(record)
    return false if validate_name(record, :full_name)
    return false if validate_age(record: record)

    true
  end

  def validate_name(record, attribute)
    name = record.send(attribute)

    if record.character_limit_exceeded?(name: name)
      record.errors[:character_limit] = "Character limit exceeded: #{name.length}"
      true
    end

    unless record.characters_valid?(name: name)
      record.errors[:invalid_character] = 'Name contains invalid characters'
      true
    end

    false
  end

  def validate_age(record:)
    return unless record.check_age(date_of_birth: record.date_of_birth) < 18

    record.errors[:minimum_age] = "Minimum age not met: #{record.check_age(date_of_birth: record.date_of_birth)}"
    true

  end
end
