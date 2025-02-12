require 'csv'

class FileProcessor

  attr_reader :file_name, :records

  # Creates a IncorrectFormatError error class
  # Parent [StandardError]

  class IncorrectFormatError < StandardError; end

  # Creates a FileProcessor object to process files
  # @param file_name [String], records [Set]
  # @return [Array] of instance variables

  def initialize(file_name:, records:)
    @file_name = file_name
    @records = records
  end

  # Saves a file to the output_data directory
  # @return [Array]

  def save_csv()
    begin
      Dir.mkdir('output_data/') unless Dir.exist?('output_data/')
      CSV.open("output_data/#{@file_name}.csv",
               'w', write_headers: true, headers: %w[firstNames lastName dateOfBirth Address yearsAtAddress passportNumber nationalInsuranceNumber errors]) do |line|
        @records.each { |record| line << record }
      end
    rescue Errno::ENOENT => error
      raise "Error whilst attempting to save file: #{error}"
    end
  end

  # Creates an array of records with a specific error
  # @return [Array]

  def filter_by_error(error_type:)
    raise IncorrectFormatError, "Error type must be a symbol not a: #{error_type.class}" unless error_type.is_a? Symbol
    @records.select do |invalid_record|
      invalid_record.last.key?(error_type)
    end
  end

  # Creates an array of records with more than two first names
  # @return [Array]

  def filter_by_name_count(records:)
    names = records.select do |record|
      record.first.count(' ') > 2
    end
    names.count
  end
end
