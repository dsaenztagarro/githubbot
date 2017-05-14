class JobsSerializer
  def initialize(job)
    @job = job
  end

  def to_json
    {
      data: {
        id: job_id,
        type: 'job',
        attributes: job_attributes,
        links: {
          self: job_url
        }
      }
    }.to_json
  end

  def job_document
    @job_document ||= @job.as_document.as_json
  end

  def job_id
    job_document['_id']['$oid']
  end

  def job_url
    URI::HTTP.build(host: 'localhost', port: 5000, path: "/jobs/#{job_id}").to_s
  end

  def job_attributes
    job_document.select { |key, _value| key != '_id' }
  end
end
