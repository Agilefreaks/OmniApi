require_relative 'base_token_generator'

module Oauth
  class BaseDelegatingTokenGenerator < Oauth::BaseTokenGenerator
    def self.generate(client, req)
      delegate_generator_class(req).generate(client, req)
    end

    def self.delegate_generator_class(_req)
      fail NotImplementedError
    end

    def self.classify(symbol)
      symbol.to_s.split('_').map(&:capitalize).join
    end
  end
end
