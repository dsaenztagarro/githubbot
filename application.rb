require 'sinatra'
require 'sinatra/reloader' if development?

require 'json'
require 'mongo'
require 'mongoid'
require 'yaml'

Dir.glob('lib/**/*.rb').each { |file| require_relative file }

configure do
  set :port, 5000
  set(:config) { }

  Mongoid.load!('config/mongoid.yml')
  Application.load('config/config.yml')
end

helpers do
  def h(text)
    Rack::Utils.escape_html text
  end
end

def github_service
  @github_service ||= Github::Service.new(settings.config)
end

get '/version' do
  erb :version
end

get '/jobs' do
  collection = Job.limit(30).to_a
  @jobs = JobDecorator.wrap(collection)
  erb :'jobs/index'
end

get '/jobs/:id' do |job_id|
  job = Job.find(job_id)
  @job = JobDecorator.new(job)
  erb :'jobs/show'
end

post '/pull_requests' do
  payload = JSON.parse(request.body.read)
  service = ScmService.new
  service.create_pull_request(payload)
end

post '/hooks' do
  payload = JSON.parse(request.body.read)
  client = Github::Client.new(settings.config)
  client.process(payload)
end
