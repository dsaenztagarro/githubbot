require_relative 'test_helper'
require_relative 'support/git/test/methods'
require 'byebug'

class PostPullRequestsGitTest < Minitest::Test
  include Rack::Test::Methods
  include Git::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    # Create empty repository
    path = create_bare_repo
    # Clone repo and push first commit
    Dir.chdir(clone_repo(path)) do
      File.open('A.txt', 'w') { |file| file.puts('hello world') }
      `git add A.txt`
      `git commit -m 'Initial commit'`
      `git push --set-upstream origin master`
    end
    # Clone again the repo with custom directory name to avoid error:
    # fatal: destination path 'project-xxxxxxxxxx' already exists and is not an empty directory.
    @repo_url = clone_repo(path, directory: "project-2-#{timestamp}")
  end

  def teardown
    FileUtils.remove_entry base_dir
  end

  def test_post_pull_requests
    Dir.chdir(@repo_url) do
      `git checkout -b 1-fake-issue`
      File.open('B.txt', 'w') { |file| file.puts("good bye") }
      `git add B.txt`
      `git commit -m 'This PR implements #1'`
      `git push --set-upstream origin 1-fake-issue`
    end
    ScmService.stub :github_repository, "dsaenztagarro/project" do
      VCR.use_cassette("post_pull_requests_github") do
        data = { target_dir: @repo_url }
        post '/pull_requests', data.to_json, "CONTENT_TYPE" => "application/json"
        assert last_response.ok?
      end
    end
  end
end
