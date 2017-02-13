require 'open3'

module Git
  class Repository
    attr_reader :dir, :log

    # @param dir [String] local dir path of a git repository
    # @param log [StringIO] log buffer
    def initialize(dir, log = StringIO.new)
      @dir = dir.freeze
      @log = log
    end

    # Getters
    #

    def remote_origin_url
      if Sinatra::Application.test?
        "git@github.com:dsaenztagarro/githubbot.git"
      else
        Dir.chdir(dir) { `git config --get remote.origin.url`.chomp }
      end
    end

    def current_branch
      @current_branch ||=
        Dir.chdir(dir) { `git rev-parse --abbrev-ref HEAD`.chomp }
    end

    # Checkers
    #

    # @return [Boolean] Marks whether or not are changes pending to be commited
    def uncommited_changes?
      run "git status --short" do |outerr, _status|
        !outerr.chomp.empty?
      end
    end

    def unpushed_commits?
      run "git log origin/#{current_branch}..#{current_branch}" do |outerr, _|
        !outerr.chomp.empty?
      end
    end

    # @return [Boolean] Marks whether it is configured a remote upstream for
    #   current branch
    def remote?
      !`git config branch.#{current_branch}.remote`.chomp.empty?
    end

    # Actions
    #

    def push
      if remote?
        run 'git push'
      else
        run "git push --set-upstream origin #{current_branch}"
      end
    end

    def to_local_repository
      LocalRepository.new(type: "git",
                          dir: dir,
                          branch_name: current_branch)
    end

    private

    def run(command)
      Dir.chdir(dir) do
        outerr, status = ::Open3.capture2e(command)
        log.puts "$ #{command}"
        log.puts outerr
        return yield(outerr, status) if block_given?
        status.success?
      end
    end
  end
end
