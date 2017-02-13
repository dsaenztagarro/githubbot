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
    job_type.gsub('_', ' ').upcase
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

  def repository_name
    pull_request.platform_repository.settings["name"]
  end

  def repository_url
    pull_request.platform_repository.settings["html_url"]
  end

  def owner_name
    pull_request.platform_repository.settings["owner"]["login"]
  end

  def owner_url
    pull_request.platform_repository.settings["owner"]["html_url"]
  end

  def local_repository_path
    pull_request.local_repository.dir
  end

  def local_branch_name
    pull_request.local_repository.branch_name
  end
end
