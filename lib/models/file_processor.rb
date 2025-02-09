require 'csv'

class FileProcessor

  attr_reader :file_name, :records

  def initialize(file_name:, records:)
    @file_name = file_name
    @records = records
  end

  def save_csv()
    begin
      Dir.mkdir('output_data/') unless Dir.exist?('output_data/')
      CSV.open("output_data/#{@file_name}.csv",
               'w', write_headers: true, headers: %w[firstNames lastName dateOfBirth Address yearsAtAddress passportNumber nationalInsuranceNumber errors]) do |line|
        @records.each { |record| line << record }
      end
    rescue Errno::ENOENT => error
      raise "Error whilst attempting to save file: #{error}"
    else
      true
    end
  end
end
