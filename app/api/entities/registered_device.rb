require_relative 'timestamps'

module API
  module Entities
    class RegisteredDevice < Timestamps
      expose :identifier, :name, :registration_id, :public_key
    end
  end
end
