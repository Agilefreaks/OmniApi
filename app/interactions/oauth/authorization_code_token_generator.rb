module Oauth
  class AuthorizationCodeTokenGenerator < Oauth::BaseTokenGenerator
    def self.generate(client, req)
      @user = find_user(req)
      super
    end

    protected

    def self.find_user(req)
      User.find_by_code(req.code)
    end

    def self.generate_core(client, req)
      @user.invalidate_authorization_code(req.code)
      build_access_token_for(@user, client.id)
    end

    def self.authorize!(_, req)
      return unless @user.nil?

      NewRelic::Agent.add_custom_parameters(req.env)
      NewRelic::Agent.notice_error(req.invalid_grant!)
    end
  end
end