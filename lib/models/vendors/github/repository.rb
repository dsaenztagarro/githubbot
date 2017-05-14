module Vendors
  module Github
    class Repository
      attr_reader :name, :client

      def initialize(name, client = Github::Client.new)
        @name = name
        @client = client
      end

      # @param url [String] Git repository remote origin url
      def self.for_url(url)
        if match = /git@(?<hostname>.*):(?<repository>.*).git/.match(url)
          Github::Repository.new(match['repository'])
        end
      end

      def default_branch
        repo['default_branch']
      end

      def as_json
        repo.to_hash
      end

      private

      def repo
        @repo ||= client.repository(name)
      end
    end
  end
end
