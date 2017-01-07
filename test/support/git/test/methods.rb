module Git
  module Test
    module Methods
      def base_dir
        @base_dir ||= Dir.mktmpdir
      end

      def create_bare_repo
        File.join(base_dir, "project-#{timestamp}.git").tap do |path|
          Dir.mkdir(path)
          Dir.chdir(path) { `git init --bare` }
        end
      end

      def clone_repo(repo_path)
        Dir.chdir(base_dir) do
          system("git clone #{repo_path}")
        end
        repo_path.sub('.git','')
      end

      def timestamp
        Time.now.to_i
      end
    end
  end
end
