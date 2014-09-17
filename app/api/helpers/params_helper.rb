module ParamsHelper
  extend Grape::API::Helpers

  def declared_params
    declared(params)
  end

  def merged_params
    merge_access_token(declared_params)
  end

  def merge_access_token(params)
    params = params.merge(access_token: @current_token.token)
    params = params.merge(client_version: headers['Client-Version']) unless headers['Client-Version'].nil?

    params
  end

  def auth_headers
    {
      'Authorization' => {
        description: 'The authorization token.',
        required: true
      }
    }
  end

  def client_version_headers
    {
      'Client-Version' => {
        description: 'The client version.',
        required: false
      }
    }
  end

  def omni_headers
    {
      headers: auth_headers.merge(client_version_headers)
    }
  end

  module_function :omni_headers, :auth_headers, :client_version_headers
end
