require 'sinatra'
require 'yaml'
require 'json'
require 'byebug'

Dir.glob('lib/**/*.rb').each { |file| require_relative file }

configure do
  set :port, 5000
  set(:vendor) { YAML.load_file('config/config.yml') }
end

post '/events' do
  debugger
  payload = JSON.parse(request.body.read)
  service = Github::Service.new
  service.process(payload)
end
