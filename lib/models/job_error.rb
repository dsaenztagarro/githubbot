class JobError
  include Mongoid::Document

  field :message, type: String
  field :backtrace, type: Array
end
