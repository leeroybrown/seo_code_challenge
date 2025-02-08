require 'nokogiri'
require 'nori'
require 'simple_symbolize'

require_relative 'models/record'
require_relative 'models/record_processor'

processor = RecordProcessor.new(file_path: './data/records.xml')
results = processor.process

puts "Valid Records: #{results[:valid].count}"
puts "Invalid Records: #{results[:invalid].count}"
binding.irb

