require 'nokogiri'
require 'nori'
require 'simple_symbolize'

doc = Nokogiri::XML(File.open('./data/records.xml')).to_s
parser = Nori.new(convert_tags_to: ->(h) { SimpleSymbolize.symbolize(h) })
binding.irb
x = parser.parse(doc)
