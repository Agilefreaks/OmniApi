module API
  module Entities
    class RegisteredDevice < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt.iso8601 }

      expose :identifier, :name, :registration_id, :just_created

      with_options(format_with: :iso_timestamp) do
        expose :created_at
        expose :updated_at
      end
    end
  end
end
