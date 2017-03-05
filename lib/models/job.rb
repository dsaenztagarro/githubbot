class Job
  include Mongoid::Document

  field :status, type: String
  field :log, type: String
  field :job_type, type: String
  field :created_at, type: DateTime

  embeds_one :pull_request
  embeds_one :job_error
end
