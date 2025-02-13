# frozen_string_literal: true

require 'nokogiri'
require 'nori'
require 'simple_symbolize'

require_relative 'models/record'
require_relative 'models/record_processor'
require_relative 'models/file_processor'

processor = RecordProcessor.new(file_path: './data/records.xml')
results = processor.process

# process valid records
valid_files = FileProcessor.new(file_name: 'valid_records', records: results[:valid])
valid_files.save_csv
valid_records_count = valid_files.filter_by_name_count(records: results[:valid])

# process invalid records
invalid_files = FileProcessor.new(file_name: 'invalid_records', records: results[:invalid])
invalid_files.save_csv
identity_number_errors = invalid_files.filter_by_error(error_type: :identity_numbers)
years_at_address_errors = invalid_files.filter_by_error(error_type: :years_at_address)
invalid_records_count = invalid_files.filter_by_name_count(records: results[:invalid])

# Output summary to the terminal
puts 'Summary of records.xml'
puts '======================='
puts "Number of valid records: #{results[:valid].count}"
puts "Number of invalid records: #{results[:invalid].count}"
puts "Total number of records processed: #{results[:valid].count + results[:invalid].count}"
puts
puts "Number of people with no passport number and no NI number: #{identity_number_errors.count}"
puts "Number of people who have lived at their address for less than 5 years: #{years_at_address_errors.count}"
puts "Number of people with more than two words in their first name: #{valid_records_count + invalid_records_count}"
