require 'simplecov'
require 'simplecov-console'
require 'simplecov_json_formatter'

SimpleCov.minimum_coverage 80
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
                                                                 SimpleCov::Formatter::Console,
                                                                 SimpleCov::Formatter::JSONFormatter
                                                               ])
SimpleCov.start do
  track_files 'lib/**/*.rb'
  add_filter 'app.rb'
end

require 'simple_symbolize'
require 'nokogiri'
require 'nori'

require_relative '../lib/modules/validation'
require_relative '../lib/models/record'
require_relative '../lib/models/record_processor'
require_relative '../lib/models/file_processor'

# See https://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
