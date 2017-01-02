require 'sinatra'
require 'sinatra/reloader' if development?
require 'yaml'
require 'json'
require 'byebug'

Dir.glob('lib/**/*.rb').each { |file| require_relative file }

configure do
  set :port, 5000
  set(:config) { YAML.load_file('config/config.yml') }
end

get '/version' do
  erb :version
end

post '/hooks' do
  payload = JSON.parse(request.body.read)
  service = Github::Service.new(settings.config)
  service.process(payload)
end
