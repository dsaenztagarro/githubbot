class JobRepository
  def find(job_id)
    job = Job.find(job_id)
  end

  def all
    Job.desc(:created_at).limit(30).to_a
  end

  def create_pull_request_job(args)
    Job.create!(args: args,
                job_type: 'pull_request',
                status: 'created',
                created_at: DateTime.now)
  end

  # @param job [Job]
  # @param result [PullRequestResult]
  def update_pull_request_job(job, result)
    pull_request = PullRequest.new(result.as_json)

    result_error = result.error

    job_error = JobError.new(
      message: result_error.message,
      backtrace: result_error.backtrace
    ) if result_error

    job.update!(status: result.status,
                updated_at: DateTime.now,
                pull_request: pull_request,
                job_error: job_error)
  end
end
