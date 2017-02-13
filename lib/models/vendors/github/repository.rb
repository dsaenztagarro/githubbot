module Vendors
  module Github
    class Repository
      attr_reader :name, :client

      def initialize(name, client = Github::Client.new)
        @name = name
        @client = client
      end

      def settings
        @settings ||= client.repository(name)
      end

      def to_platform_repository
        PlatformRepository.new(platform_name: "Github",
                               repository_name: name,
                               settings: settings.to_hash)

      end

      # @param url [String] Git repository remote origin url
      def self.for_url(url)
        if match = /git@(?<hostname>.*):(?<repository>.*).git/.match(url)
          Github::Repository.new(match["repository"])
        end
      end

      def default_branch
        settings['default_branch']
      end
    end
  end
end
