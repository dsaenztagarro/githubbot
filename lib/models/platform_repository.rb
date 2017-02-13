class PlatformRepository
  include Mongoid::Document

  field :platform_name, type: String
  field :repository_name, type: String
  field :settings, type: Hash
end
