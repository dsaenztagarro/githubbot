require_relative 'test_helper'

class ApplicationTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_version
    get '/version'
    assert last_response.ok?
  end

  def test_hooks
    data = { owner: 'bebanjo',
             repo: 'scmbot',
             branch: '1-my-branch' }
    post '/hooks', data.to_json, "CONTENT_TYPE" => "application/json"
    assert last_response.ok?
  end
end
