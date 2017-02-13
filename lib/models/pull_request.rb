class PullRequest
  include Mongoid::Document

  field :repo_type, type: String
  field :platform_name, type: String

  embeds_one :local_repository
  embeds_one :platform_repository
  embeds_one :pull_request
  embeds_one :pull_request_response
end
