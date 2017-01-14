require 'stringio'

class ScmService
  attr_accessor :client

  def initialize(client)
    @client = client
  end

  def create_pull_request(request)
    target_dir = request['target_dir']

    puts "Action: pull_request"
    puts "Target dir: #{target_dir}"

    log = StringIO.new
    repo = Git::Repository.new(target_dir, log)

    repository  = self.class.github_repository(repo.remote_url)
    branch_name = repo.branch_name
    base        = 'master'
    head        = branch_name
    issue_id    = branch_name.to_i
    body        = "This PR implements ##{issue_id}"

    return unless repo.nothing_to_commit?

    if repo.push
      issue = client.issue(repository, issue_id)
      response = client.create_pull_request(
        repository, base, head, issue['title'], body)
    end

    Github::PullRequest.create!(
      target_dir: target_dir, repository: repository, base: base, head: head) #, title: title, body: body)

  rescue Octokit::UnprocessableEntity => _error
  end

  def self.github_repository(url)
    match = /git@(?<hostname>.*):(?<repository>.*).git/.match(url)
    match && match["repository"]
  end
end
