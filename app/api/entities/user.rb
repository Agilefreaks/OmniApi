require_relative 'timestamp_base_entity'

module API
  module Entities
    class User < Grape::Entity
      expose :email
      expose :first_name
      expose :last_name
      expose :image_url
      expose :via_omnipaste
      expose :access_token do |user, _options|
        user.access_tokens.last.token
      end
      expose :contacts_updated_at

      format_with(:iso_timestamp) { |dt| dt.iso8601 }

      with_options(format_with: :iso_timestamp) do
        expose :created_at
        expose :updated_at
      end
    end
  end
end
