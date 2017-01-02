require 'octokit'

module Github
  class Service
    def initialize(config)
      @config = config
      @client = Octokit::Client.new access_token: github_access_token
    end

    def process(request)
      issue = client.issue(request['repo'], request['issue_number'])
      issue.to_attrs.merge!(labels: issue.labels)
    end

    private

    attr_accessor :config, :client

    def github_access_token
      config["github"]["personal_access_token"]
    end
  end
end
