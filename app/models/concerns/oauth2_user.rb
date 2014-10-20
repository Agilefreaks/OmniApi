module Concerns
  module OAuth2User
    extend ActiveSupport::Concern

    included do
      embeds_many :authorization_codes

      index({ 'authorization_codes.code' => 1, 'authorization_codes.active' => 1 },
            { unique: true, sparse: true })
    end

    def invalidate_authorization_code(code)
      authorization_codes.where(code: code).update(active: false)
      save
    end

    def authorization_code
      authorization_codes.order_by(created_at: 1).last
    end

    module ClassMethods
      def find_by_code(code)
        User.where(authorization_codes:
                     { '$elemMatch' =>
                         { code: code.strip, active: true, :expires_at.gt => Time.now.utc }
                     }).first
      end
    end
  end
end
