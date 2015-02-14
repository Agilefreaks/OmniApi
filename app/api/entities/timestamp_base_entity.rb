require_relative 'base_entity'

module API
  module Entities
    class TimestampBaseEntity < BaseEntity
      format_with(:iso_timestamp) { |dt| dt.iso8601 }

      with_options(format_with: :iso_timestamp) do
        expose :created_at
        expose :updated_at
      end
    end
  end
end
