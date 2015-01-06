module API
  module Entities
    class BaseEntity < Grape::Entity
      format_with(:to_s) { |field| field.to_s }
      format_with(:iso_timestamp) { |dt| dt.iso8601 }

      with_options(format_with: :to_s) do
        expose :id
      end

      with_options(format_with: :iso_timestamp) do
        expose :created_at
        expose :updated_at
      end
    end
  end
end
