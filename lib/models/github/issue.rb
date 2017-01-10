module Github
  class Issue
    include Mongoid::Document

    field :data, type: Hash
  end
end
