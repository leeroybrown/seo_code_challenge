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

# TODO: the below needs to be removed
puts "Valid Records: #{results[:valid].count}"
puts "Invalid Records: #{results[:invalid].count}"
