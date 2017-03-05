require 'octokit'
require_relative '../errors'

module Vendors
  module Github
    class Client
      attr_accessor :client

      def initialize(config = Application.config)
        @config = config
        @client = Octokit::Client.new user: github_user,
                                     password: github_password
        @access_token = @client.create_authorization scope: ["repo"]
        # @client = Octokit::Client.new access_token: access_token
      end

      def process(request)
        issue = client.issue(request['repo'], request['issue_number'])
        issue.to_attrs.merge!(labels: issue.labels)
      end

      def repository(repo)
        client.repository(repo)
      end

      def issue(*args)
        client.issue(*args)
      end

      def create_pull_request(repo:, base:, head:, title:, body:)
        client.create_pull_request(repo, base, head, title, body)
      end

      private

      attr_reader :config

      def github_access_token
        config["github"]["personal_access_token"]
      end

      def github_user
        config["github"]["user"]
      end

      def github_password
        config["github"]["password"]
      end
    end
  end
end
