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
    def nothing_to_commit?
      Dir.chdir(dir) do
        command_log, _status = run "git status --short"
        command_log.chomp.empty?
      end
    end

    def url
      @name ||= begin
        Dir.chdir(dir) do
          `git remote -v | awk 'NR == 1 && /origin/ {print $2}'`.chomp
        end
      end
    end

    def push
      Dir.chdir(dir) do
        command = "git push"
        outerr, status = ::Open3.capture2e(command)
        write_log(command, outerr)
        return true if status.success?

        command = "git push --set-upstream origin #{branch_name}"
        outerr, status = ::Open3.capture2e(command)
        write_log(command, outerr)
        status.success?
      end
    end

    def branch_name
      @branch_name ||= Dir.chdir(dir) { `git rev-parse --abbrev-ref HEAD`.chomp }
    end

    private

    def run(command)
      Dir.chdir(dir) do
        outerr, status = ::Open3.capture2e(command)
        write_log(command, outerr)
        [outerr, status]
      end
    end

    def write_log(command, outerr)
      log.puts "$ #{command}"
      log.puts outerr
    end
  end
end
