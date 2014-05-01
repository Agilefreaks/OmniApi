module Concerns
  module OAuth2Finders
    extend ActiveSupport::Concern

    included do
      embeds_many :access_tokens

      index('access_tokens.token' => 1)
      index('access_tokens.refresh_token.token' => 1)
    end

    module ClassMethods
      def find_by_token(token)
        where(
          'access_tokens.token' => token,
          :'access_tokens.expires_at'.gt => Date.current).first ||
          where(
            'access_tokens.refresh_token.token' => token).first unless token.nil?
      end
    end
  end
end