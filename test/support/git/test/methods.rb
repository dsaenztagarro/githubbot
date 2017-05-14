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

      def clone_repo(repo_path, opts = {})
        directory = opts[:directory]
        directory_path = File.join(base_dir, directory) if directory
        Dir.chdir(base_dir) do
          system("git clone #{repo_path} #{directory_path}")
        end
        directory_path || repo_path.sub('.git', '')
      end

      def timestamp
        DateTime.now.strftime('%Q')
      end
    end
  end
end
