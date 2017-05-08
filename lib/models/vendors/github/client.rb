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

      # @param repo [String]
      # @param number [Fixnum]
      # @return [Vendors::Github::Response::Issue]
      def issue(repo, number)
        response = client.issue(repo, number)
        Vendors::Github::Responses::Issue.new(response)
      end

      def issue_comments(*args)
        client.issue_comments(*args)
      end

      # @param args [Vendors::Github::PullRequestArgs]
      # @return [Vendors::Github::Response::CreatePullRequest]
      def create_pull_request(args)
        response = client.create_pull_request(
          args.repo, args.base, args.head, args.title, args.body)
        Vendors::Github::Responses::CreatePullRequest.new(response)
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
