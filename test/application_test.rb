require_relative 'test_helper'

class ApplicationTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_version
    get '/version'
    assert last_response.ok?
  end

  private

  def setup_git_local_project(dir, remote_path)
    File.join(dir, 'project').tap do |path|
      Dir.mkdir(path)
      Dir.chdir(path) do
        File.create('A.txt') do |file|
          file.puts("hello world")
        end
        system("git remote add origin #{remote_path}")
      end
    end
  end
end
