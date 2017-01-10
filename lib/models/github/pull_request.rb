module Github
  class PullRequest
    include Mongoid::Document

    field :target_dir, type: String

    field :repository, type: String
    field :base, type: String
    field :head, type: String
    field :title, type: String
    field :body, type: String

    embeds_one :issue
    embeds_one :response
  end
end
