require_relative 'timestamps'

module API
  module Entities
    class Device < Timestamps
      expose :id, :name, :provider, :registration_id, :public_key
    end
  end
end
