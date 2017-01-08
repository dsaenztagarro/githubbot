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

def github_service
  @github_service ||= Github::Service.new(settings.config)
end

get '/version' do
  erb :version
end

post '/pull_requests' do
  payload = JSON.parse(request.body.read)
  client = Github::Client.new(settings.config)
  service = ScmService.new(client)
  service.create_pull_request(payload)
end

post '/hooks' do
  payload = JSON.parse(request.body.read)
  client = Github::Client.new(settings.config)
  client.process(payload)
end
