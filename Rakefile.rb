require 'rake/testtask'

namespace :docker do
  task :setup do
    Dir.chdir('test/support/docker') do
      system("docker build -t 'gitserver:v1' .")
    end
  end
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

task default: :test
