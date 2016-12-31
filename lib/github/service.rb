require 'octokit'

module Github
  class Service
    def initialize(config)
      @config = config
      @client = Octokit::Client.new access_token: github_access_token
    end

    def process(raw_event)
      print raw_event
      print config
    end

    def current
      repos = client.org_repos('Bebanjo', type: 'all', per_page: 100)
      put repos
    end

    private

    attr_accessor :config, :client

    def github_access_token
      config["github"]["personal_access_token"]
    end
  end
end
