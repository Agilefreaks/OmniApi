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
        client_id = options[:client_id]
        access_token = user.access_tokens.active.for_client(client_id).first if client_id
        access_token ||= user.access_tokens.active.first

        access_token.try(:token)
      end

      format_with(:iso_timestamp) { |dt| dt.iso8601 unless dt.nil? }

      with_options(format_with: :iso_timestamp) do
        expose :created_at
        expose :updated_at
        expose :contacts_updated_at, safe: true
      end
    end
  end
end
