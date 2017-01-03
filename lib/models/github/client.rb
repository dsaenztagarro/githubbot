require 'octokit'

module Github
  class Client
    attr_accessor :config, :client

    def initialize(config)
      @config = config
      @client = Octokit::Client.new access_token: github_access_token
      @client.login
    end

    def process(request)
      issue = client.issue(request['repo'], request['issue_number'])
      issue.to_attrs.merge!(labels: issue.labels)
    end

    def issue(*args)
      client.issue(*args)
    end

    def create_pull_request(repo, base, head, title, body)
      client.create_pull_request(repo, base, head, title, body)
    end

    private

    def github_access_token
      config["github"]["personal_access_token"]
    end
  end
end
