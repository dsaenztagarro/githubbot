require 'octokit'
require_relative '../errors'

module Vendors
  module Github
    class Client
      attr_accessor :client

      def initialize(config = Application.config)
        @config = config
        @client = Octokit::Client.new login: github_access_token,
                                      password: 'x-oauth-basic'
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

      # @return [Hash] related to Sawyer::Resource
      def create_pull_request(repo:, base:, head:, title:, body:)
        response = client.create_pull_request(repo, base, head, title, body)
        response.to_hash
      end

      private

      attr_reader :config

      def github_access_token
        config['github']['personal_access_token']
      end

      def github_user
        config['github']['user']
      end

      def github_password
        config['github']['password']
      end
    end
  end
end
