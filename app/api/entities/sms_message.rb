require_relative 'timestamps'

module API
  module Entities
    class SmsMessage < Timestamps
      expose :phone_number, if: ->(message, _options) { message.phone_number_list.empty? }
      expose :phone_number_list, unless: ->(message, _options) { message.phone_number_list.empty? }
      expose :content, if: ->(message, _options) { message.content_list.empty? }
      expose :content_list, unless: ->(message, _options) { message.content_list.empty? }
    end
  end
end
