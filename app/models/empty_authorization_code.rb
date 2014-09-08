class EmptyAuthorizationCode
  include Mongoid::Document
  include Mongoid::Timestamps

  field :emails, type: Array
end