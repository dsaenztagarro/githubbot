module Github
  class PullRequestResponse
    include Mongoid::Document

    field :data, type: Hash
  end
end
