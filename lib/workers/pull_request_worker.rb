require 'stringio'

class PullRequestWorker
  def initialize(job, job_repository = JobRepository.new)
    @job = job
    @job_repository = job_repository
  end

  def execute
    git_repo = Git::Repository.new(target_dir)

    return if git_repo.uncommited_changes?

    if git_repo.unpushed_commits?
      return unless git_repo.push
    end

    platform = Vendors::Platform.for_url(git_repo.remote_origin_url)

    if platform
      platform.load_user 'Bebanjo'
      result = platform.create_pull_request(git_repo)
      job_repository.update_pull_request_job(job, result)
    end
  end

  private

  attr_reader :job, :job_repository

  def target_dir
    job.args['target_dir']
  end
end
