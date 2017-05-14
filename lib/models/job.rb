class Job
  include Mongoid::Document

  field :args, type: Hash
  field :job_type, type: String
  field :status, type: String
  field :log, type: String
  field :created_at, type: DateTime
  field :updated_at, type: DateTime

  embeds_one :pull_request
  embeds_one :job_error
end
