require_relative '../test_helper'
require 'open3'

class ScmServiceTest < Minitest::Test

  def test_create_pull_request_uncommited_files
    # "$ git status --short"
    # "?? test.txt\n"

    # "$ git status --short\n
    # \n
    # $ git push\n
    # Everything up-to-date\n"

    # $ git status --short\n
    # \n
    # $ git push\n
    # To git@github.com:dsaenztagarro/githubbot.git\n
    #   fd383e1..b9ccd89  8-add-badges-readme -> 8-add-badges-readme\n
    #

  end

  def test_create_pull_request
    client = Minitest::Mock.new
    client.expect(:issue, { id: 1 }, ["mylogin/myrepo", 99])
    client.expect(:create_pull_request, true)

    service = ScmService.new(client)

    dir = Dir.mktmpdir
    request = { 'target_dir' => dir }

    backstick_stub = Proc.new do |cmd|
      case cmd
      when "git rev-parse --abbrev-ref HEAD"
        "99-feature-test-branch"
      when "git remote -v | awk 'NR == 1 && /origin/ {print $2}'"
        "git@github.com:mylogin/myrepo.git"
      end
    end

    capture2e_stub = Proc.new do |cmd|
      case cmd
      when "git push"
        resource = Minitest::Mock.new
        [resource, true]
      when "git push --set-upstream origin 99-feature-test-branch"
        resource = Minitest::Mock.new
        [resource, true]
      end
    end

    service.stub :`, backstick_stub do

      Open3.stub :capture2e, capture2e_stub do

        service.create_pull_request(request)
      end
    end

  ensure
    FileUtils.remove_entry dir
  end
end
