class LocalRepository
  include Mongoid::Document

  field :type, type: String
  field :dir, type: String
  field :branch_name, type: String
end
