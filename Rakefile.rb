require 'rake/testtask'
require 'octokit'
require 'yaml'
require 'byebug'

namespace :github do
  task :create_access_token do
    config_file_path = File.expand_path('./config/config.yml')
    config   = YAML.load_file(config_file_path)

    login    = config['github']['user']
    password = config['github']['password']

    client = Octokit::Client.new login: login, password: password

    scopes = %w(admin:gpg_key admin:org admin:org_hook admin:public_key
                admin:repo_hook delete_repo gist notifications repo user)

    user = begin
      # To keep our SMS delivery fast for all 2FA users, the API only sends the
      # OTP when sending a POST or PUT to the Authorizations API
      client.create_authorization scopes: scopes,
                                  note: "Mazinger Z - #{Time.now}"
    rescue Octokit::OneTimePasswordRequired
      print 'OTP: '
      otp = STDIN.noecho(&:gets).chomp

      auth = client.create_authorization scopes: scopes,
                                         note: "Mazinger Z - #{Time.now}",
                                         headers: { 'X-GitHub-OTP' => otp }

      puts "New Oauth access token: #{auth.token}"

      puts 'Validating new token works...'

      client = Octokit::Client.new login: auth.token,
                                   password: 'x-oauth-basic', auto_paginate: true

      repo = client.repositories(nil, type: 'all').first
      puts(client.repository(repo.full_name))
    end
  end
end

namespace :docker do
  task :setup do
    Dir.chdir('test/support/docker') do
      system("docker build -t 'gitserver:v1' .")
    end
  end
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

task default: :test
