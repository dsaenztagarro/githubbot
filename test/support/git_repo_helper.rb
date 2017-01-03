module GitRepoHelper
  def setup_git_repo
    backstick_stub = Proc.new do |cmd|
      debugger
      case cmd
      when "git rev-parse --abbrev-ref HEAD"
        "99-feature-test-branch"
      when "git remote -v | awk 'NR == 1 && /origin/ {print $2}'"
        "git@github.com:mylogin/myrepo.git"
      end
    end

    GitRepo.stub :`, backstick_stub do
      debugger
      yield
    end
  end
end
