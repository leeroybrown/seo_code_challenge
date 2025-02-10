require 'nokogiri'
require 'nori'
require 'simple_symbolize'

require_relative 'models/record'
require_relative 'models/record_processor'
require_relative 'models/file_processor'

processor = RecordProcessor.new(file_path: './data/records.xml')
results = processor.process

valid_files = FileProcessor.new(file_name: 'valid_records', records: results[:valid])
valid_files.save_csv

invalid_files = FileProcessor.new(file_name: 'invalid_records', records: results[:invalid])
invalid_files.save_csv

invalid_identity_numbers = results[:summarise_invalid].select { |invalid_record| invalid_record.errors.key?(:identity_numbers) }
years_at_address = results[:summarise_invalid].select { |invalid_record| invalid_record.errors.key?(:years_at_address) }
more_than_two_words = results[:summarise_invalid].select { |invalid_record| invalid_record.first_names.split.count > 2 } +
  results[:summarise_valid].select { |valid_record| valid_record.first_names.split.count > 2 }

# TODO: the below needs to be removed
puts 'Summary of records.xml'
puts '========================'
puts "Number of valid records: #{results[:valid].count}"
puts "Number of invalid records: #{results[:invalid].count}"
puts "Total number of records processed: #{results[:valid].count + results[:invalid].count}"
puts
puts "Number of people with no passport number and no NI number: #{invalid_identity_numbers.count}"
puts "Number of people who have lived at their address for less than 5 years: #{years_at_address.count}"
puts "Number of people with more than two words in their first name: #{more_than_two_words.count}"

