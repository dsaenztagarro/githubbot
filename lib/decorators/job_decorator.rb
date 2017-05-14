class JobDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def job_path
    "/jobs/#{id}"
  end

  def success?
    status.eql? 'success'
  end

  def name
    job_type.tr('_', ' ').upcase
  end

  def error_message
    job_error.message
  end

  def error_backtrace
    job_error.backtrace
  end

  def created_at
    super.strftime('%Y/%m/%d %H:%M:%S')
  end

  def repo_name
    platform_repo['name']
  end

  def repo_url
    platform_repo['html_url']
  end

  def owner_name
    platform_repo['owner']['login']
  end

  def owner_url
    platform_repo['owner']['html_url']
  end

  def local_repo_dir
    local_repo['dir']
  end

  def local_repo_branch
    local_repo['branch']
  end

  def platform_repo
    pull_request.platform_repo
  end

  def local_repo
    pull_request.local_repo
  end
end
