module Oauth
  class RefreshTokenUserClientAssociationTokenGenerator < BaseRefreshTokenTokenGenerator
    def self.find_token(req)
      user_client_association = UserClientAssociation.find_by_token(req.refresh_token)
      user_client_association.access_token if user_client_association
    end
  end
end
