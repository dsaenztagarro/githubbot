module Users
  module Bebanjo
    module Github
      class Config

        # @param git_repo    [ Git::Repository]
        # @param github_repo [ Github::Repository]
        # @param client      [ Github::Client]
        # @return [Hash]
        def get_pull_request_config(git_repo, github_repo, client)
          branch_name = git_repo.current_branch
          issue_id    = branch_name.to_i
          issue       = client.issue(github_repo.name, issue_id)

          { repo: github_repo.name,
            base: github_repo.default_branch,
            head: branch_name,
            title: issue['title'],
            body: "This PR implements ##{issue_id}" }
        end

      end
    end
  end
end
