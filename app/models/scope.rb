class Scope
  include Mongoid::Document

  field :key, type: Symbol
  field :description, type: String
end
