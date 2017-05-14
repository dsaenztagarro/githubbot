class PullRequest
  include Mongoid::Document

  field :args, type: Hash
  field :local_repo, type: Hash
  field :platform_repo, type: Hash
  field :response, type: Hash
end
