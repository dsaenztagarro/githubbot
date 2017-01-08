source 'https://rubygems.org'

gem 'sinatra'

gem 'json'
gem 'octokit'
gem 'rake'

group :production do
  gem 'thin'
end

group :test do
  gem 'minitest'
  gem 'vcr'
  gem 'webmock'

  gem 'simplecov'
  gem 'codeclimate-test-reporter', '~> 1.0.0'
end

group :development do
  gem 'byebug'
  gem 'sinatra-contrib'
end
