module Concerns
  module OAuth2User
    extend ActiveSupport::Concern

    included do
      embeds_many :access_tokens
      embeds_many :authorization_codes

      index({ 'authorization_codes.code' => 1, 'authorization_codes.valid' => 1 }, { unique: true })
      index({ 'access_tokens.token' => 1, 'access_tokens.client_id' => 1 }, { unique: true })
      index({ 'access_tokens.refresh_token.token' => 1, 'access_tokens.refresh_token.client_id' => 1 },
            { unique: true })
    end

    def invalidate_authorization_code(code)
      authorization_codes.where(code: code).update(valid: false)
      save
    end

    module ClassMethods
      def find_by_code(code)
        User.where('authorization_codes.code' => code, 'authorization_codes.valid' => true).first
      end

      def find_by_token(token, client_id)
        User.where(
          'access_tokens.token' => token,
          'access_tokens.client_id' => client_id,
          :'access_tokens.expires_at'.gt => Date.current).first ||
          User.where(
            'access_tokens.refresh_token.token' => token,
            'access_tokens.refresh_token.client_id' => client_id).first
      end
    end
  end
end
