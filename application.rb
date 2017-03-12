require 'sinatra'
require 'sinatra/reloader' if development?

require 'json'
require 'mongo'
require 'mongoid'
require 'yaml'

Dir.glob('lib/**/*.rb').each { |file| require_relative file }

configure do
  set :port, 5000
  set(:config) {}

  Mongoid.load!('config/mongoid.yml')
  Application.load('config/config.yml')
end

helpers do
  def h(text)
    Rack::Utils.escape_html text
  end
end

def json_payload(request)
  JSON.parse(request.body.read)
end

get '/version' do
  erb :version
end

post '/api/jobs' do
  content_type :json
  status 202
  job = JobRepository.new.create_pull_request_job(json_payload(request))
  # Thread.new { PullRequestWorker.new(job).execute }
  PullRequestWorker.new(job).execute
  JobsSerializer.new(job).to_json
end

get '/jobs' do
  collection = JobRepository.new.all
  @jobs = JobDecorator.wrap(collection)
  erb :'jobs/index'
end

get '/jobs/:id' do |job_id|
  job = JobRepository.new.find(job_id)
  @job = JobDecorator.new(job)
  erb :'jobs/show'
end

post '/hooks' do
  payload = JSON.parse(request.body.read)
  client = Github::Client.new(settings.config)
  client.process(payload)
end
