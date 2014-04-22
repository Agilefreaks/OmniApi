class Provider
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :uid, :type => String
  field :auth, :type => String
  field :email, :type =>String

  # relations
  embedded_in :user
end