class Job
  include Mongoid::Document

  field :job_type, type: String
  field :vendor, type: String

  field :target_dir, type: String
  field :base, type: String
  field :head, type: String # the branch name
  field :created_at, type: Date
  field :scm, type: Hash

  field :created_at, type: DateTime
end
