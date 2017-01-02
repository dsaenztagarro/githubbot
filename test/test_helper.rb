require "simplecov"
SimpleCov.start

ENV['RACK_ENV'] = 'test'

require 'test/unit'
require 'rack/test'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/vcr_cassettes'
  config.hook_into :webmock
end

require_relative '../application.rb'