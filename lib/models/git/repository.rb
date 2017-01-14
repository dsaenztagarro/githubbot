require 'open3'

module Git
  class Repository
    attr_reader :dir, :log

    # @param dir [String] local dir path of a git repository
    # @param log [StringIO] log buffer
    def initialize(dir, log)
      @dir = dir.freeze
      @log = log
    end

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

    def remote_origin_url
      `git remote get-url --push origin`.chomp
    end

    alias :remote_url :remote_origin_url

    # @return [Boolean] Marks whether it is configured a remote upstream for
    #   current branch
    def remote?
      !`git config branch.#{current_branch}.remote`.chomp.empty?
    end

    def push
      if remote?
        run 'git push'
      else
        run "git push --set-upstream origin #{current_branch}"
      end
    end

    def current_branch
      @current_branch ||= Dir.chdir(dir) { `git rev-parse --abbrev-ref HEAD`.chomp }
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
