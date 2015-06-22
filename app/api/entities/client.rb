require_relative 'base_entity'
require_relative 'scope'

module API
  module Entities
    class Client < BaseEntity
      expose :name

      expose :scopes, using: API::Entities::Scope
    end
  end
end
