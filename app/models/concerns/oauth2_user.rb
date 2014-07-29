module Concerns
  module OAuth2User
    extend ActiveSupport::Concern

    included do
      embeds_many :authorization_codes

      index('authorization_codes.code' => 1, 'authorization_codes.valid' => 1)
    end

    def invalidate_authorization_code(code)
      authorization_codes.where(code: code).update(active: false)
      save
    end

    module ClassMethods
      def find_by_code(code)
        User.where(authorization_codes:
                     { '$elemMatch' =>
                         { code: code, active: true, :expires_at.gt => Time.now.utc }
                     }).first
      end
    end
  end
end
