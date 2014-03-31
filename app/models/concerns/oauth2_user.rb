module Concerns
  module OAuth2User
    extend ActiveSupport::Concern

    included do
      embeds_many :access_tokens
      embeds_many :authorization_codes

      index({ 'authorization_codes.code' => 1, 'authorization_codes.valid' => 1 }, { unique: true })
      index({ 'access_tokens.token' => 1, 'access_tokens.client_id' => 1 }, { unique: true })
      index({ 'access_tokens.refresh_token.token' => 1, 'access_tokens.client_id' => 1 }, { unique: true })
    end

    module ClassMethods
      def find_by_code(code)
        User.where('authorization_codes.code' => code, 'authorization_codes.valid' => true).first
      end

      def find_by_token(token)
        User.where('access_tokens.token' => token).first ||
          User.where('access_tokens.refresh_token.token' => token).first
      end
    end

    def invalidate_authorization_code(code)
      authorization_codes.where(code: code).update(valid: false)
      save
    end
  end
end
