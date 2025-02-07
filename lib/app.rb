require 'nokogiri'
require 'nori'
require 'simple_symbolize'

require_relative 'models/person'

doc = Nokogiri::XML(File.open('./data/records.xml')).to_s
parser = Nori.new(convert_tags_to: ->(h) { SimpleSymbolize.symbolize(h) })
x = parser.parse(doc)
x.dig(:data, :people).each do |person|
  record = Person.new(**person)
  binding.irb
end
