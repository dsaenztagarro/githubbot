module Git
  module Test
    module Methods
      def git_dir
        @git_dir ||= Dir.mktmpdir
      end

      def create_bare_repo
        File.join(git_dir, "project-#{timestamp}.git").tap do |path|
          Dir.mkdir(path)
          Dir.chdir(path) { `git init --bare` }
        end
      end

      def clone_repo(repo_path)
        Dir.chdir(git_dir) { system("git clone #{repo_path}") }
        repo_path.sub('.git','')
      end

      def timestamp
        Time.now.to_i
      end
    end
  end
end
