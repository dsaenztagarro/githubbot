ENV['RACK_ENV'] = 'test'

require 'test/unit'
require 'rack/test'

require_relative '../application.rb'
