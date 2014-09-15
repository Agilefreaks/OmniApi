module Concerns
  module OAuth2Finders
    extend ActiveSupport::Concern

    included do
      embeds_many :access_tokens

      index({ 'access_tokens.token' => 1 }, { unique: true, drop_dups: true, sparse: true })
      index({ 'access_tokens.refresh_token.token' => 1 }, { unique: true, drop_dups: true, sparse: true })
    end

    module ClassMethods
      def find_by_token(token)
        where(access_tokens: { '$elemMatch' => { token: token, expires_at: { '$gt' => Date.current } } }).first ||
          where('access_tokens.refresh_token.token' => token).first unless token.nil?
      end
    end
  end
end
