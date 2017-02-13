require 'stringio'

class ScmService
  def create_pull_request(request)
    target_dir = request['target_dir']

    git_repo = Git::Repository.new(target_dir)

    return if git_repo.uncommited_changes?

    if git_repo.unpushed_commits?
      return unless git_repo.push
    end

    platform = Vendors::Platform.for_url(git_repo.remote_origin_url)

    if platform
      platform.load_user "Bebanjo"
      platform.create_pull_request(git_repo)
    end
  end
end
