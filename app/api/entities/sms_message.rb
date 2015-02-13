require_relative 'timestamp_base_entity'

module API
  module Entities
    class SmsMessage < TimestampBaseEntity
      expose :phone_number, if: ->(message, _options) { message.phone_number_list.empty? }
      expose :phone_number_list, unless: ->(message, _options) { message.phone_number_list.empty? }
      expose :contact_name, if: ->(message, _options) { message.contact_name_list.empty? }
      expose :contact_name_list, unless: ->(message, _options) { message.contact_name_list.empty? }
      expose :content, if: ->(message, _options) { message.content_list.empty? }
      expose :content_list, unless: ->(message, _options) { message.content_list.empty? }
    end
  end
end
