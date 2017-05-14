require_relative 'test_helper'

class PostApiJobsTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    Mongoid.purge!
  end

  def test_expected_response
    creation_date = DateTime.new(2014, 12, 12, 1, 1, 1)
    DateTime.stub(:now, creation_date) do
      request_data = { target_dir: '/tmp/dir' }
      post '/api/jobs', request_data.to_json, 'CONTENT_TYPE' => 'application/json'

      payload = JSON.parse(last_response.body, symbolize_names: true)

      assert_equal last_response.status, 202
      assert_equal payload, expected_success_payload
    end
  end

  def teardown
    Mongoid.purge!
  end

  private

  def expected_success_payload
    {
      data: {
        id: last_job_id,
        type: 'job',
        attributes: {
          args: {
            target_dir: '/tmp/dir'
          },
          job_type: 'pull_request',
          status: 'created',
          created_at: '2014-12-12T01:01:01.000Z',
        },
        links: {
          self: "http://localhost:5000/jobs/#{last_job_id}"
        }
      }
    }
  end

  def last_job_id
    Job.last.id.as_json['$oid']
  end
end
