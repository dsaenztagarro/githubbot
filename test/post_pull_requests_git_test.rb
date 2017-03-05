require_relative 'test_helper'
require_relative 'support/git/test/methods'

class PostPullRequestsGitTest < Minitest::Test
  include Rack::Test::Methods
  include Git::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    # Create empty repository
    bare_repo_path = create_bare_repo
    # Clone repo and push first commit
    Dir.chdir(clone_repo(bare_repo_path)) do
      File.open('A.txt', 'w') { |file| file.puts('hello world') }
      `git add A.txt`
      `git commit -m 'Initial commit'`
      `git push --set-upstream origin master`
    end
    # Clone again the repo with custom directory name to avoid error:
    # fatal: destination path 'project-xxxxxxxxxx' already exists and is not an empty directory.
    @repo_url = clone_repo(bare_repo_path, directory: "project-2-#{timestamp}")

    Mongoid.purge!
  end

  def teardown
    FileUtils.remove_entry base_dir
  end

  def test_post_pull_requests_user
    setup_repo
    VCR.use_cassette("post_pull_requests_github", record: :new_episodes) do
      data = { target_dir: @repo_url }
      post '/pull_requests', data.to_json, "CONTENT_TYPE" => "application/json"
      assert last_response.ok?
    end
  end

  # def test_post_pull_requests_organization
  #   setup_repo
  #   ScmService.stub :github_repository, "MyFakeTestOrg/project" do
  #     VCR.use_cassette("post_pull_requests_github_organization") do
  #       data = { target_dir: @repo_url }
  #       post '/pull_requests', data.to_json, "CONTENT_TYPE" => "application/json"
  #       assert last_response.ok?
  #     end
  #   end
  # end

  private

  def setup_repo
    Dir.chdir(@repo_url) do
      `git checkout -b 1-fake-issue`
      File.open('B.txt', 'w') { |file| file.puts("good bye") }
      `git add B.txt`
      `git commit -m 'This PR implements #1'`
      `git push --set-upstream origin 1-fake-issue`
    end
  end
end
