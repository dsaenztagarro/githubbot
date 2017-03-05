module Vendors
  module Github
    class Platform
      attr_reader :client
      attr_accessor :user

      def initialize(client = Github::Client.new)
        @client = client
      end

      # @param git_repo [Git::Repository]
      def create_pull_request(git_repo)
        github_repo = Github::Repository.for_url(git_repo.remote_origin_url)
        pr_attrs = user.get_pull_request_config(git_repo, github_repo, client)
        pr_response = client.create_pull_request(pr_attrs)

        audit_pull_request(git_repo, github_repo, pr_attrs)
      rescue => error
        audit_pull_request(git_repo, github_repo, pr_attrs, error)
      end

      def load_user(user_name)
        user_config_class_name = "Users::#{user_name}::Github::Config"
        user_config_class = Kernel.const_get(user_config_class_name)
        @user = user_config_class.new
      end

      private

      attr_reader :client

      def audit_pull_request(git_repo, github_repo, pr_attrs, error = nil)
        job_status = error.nil? ? "success" : "error"

        pull_request = PullRequest.new(
          local_repository: git_repo.to_local_repository,
          platform_repository: github_repo.to_platform_repository)

        job_error = JobError.create!(
          message: error.message,
          backtrace: error.backtrace) if error

        Job.create!(status: job_status.to_s,
                    job_type: "pull_request",
                    created_at: Time.now,
                    pull_request: pull_request,
                    job_error: job_error)
      end

      def get_pull_request_data(git_repo, github_repo, client)
        raise NotImplementedError
      end
    end
  end
end
