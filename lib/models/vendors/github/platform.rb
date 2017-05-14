module Vendors
  module Github
    class Platform
      attr_reader :client
      attr_accessor :user

      def initialize(client = Github::Client.new)
        @client = client
      end

      # @param git_repo [Git::Repository]
      # @return [Vendors::Github::PullRequest]
      def create_pull_request(git_repo)
        begin
          github_repo = Github::Repository.for_url(git_repo.remote_origin_url)
          args = user.pull_request_args(git_repo, github_repo, client)
          require 'pry'; binding.pry
          response = client.create_pull_request(args)
        rescue Octokit::Error => error
          @error = error
        end

        Vendors::Responses::CreatePullRequest.new(
          args: args,
          status: @error.nil? ? 'success' : 'error',
          local_repo: git_repo,
          platform_repo: github_repo,
          response: response,
          error: @error
        )
      end

      def load_user(user_name)
        user_config_class_name = "Users::#{user_name}::Github::Config"
        user_config_class = Kernel.const_get(user_config_class_name)
        @user = user_config_class.new
      end

      private

      attr_reader :client

      # @abstract
      # @private
      #
      # @param git_repo    [ Git::Repository]
      # @param github_repo [ Github::Repository]
      # @param client      [ Github::Client]
      # @return [Hash] with keys
      def get_pull_request_data(git_repo, github_repo, client)
        raise NotImplementedError
      end
    end
  end
end
