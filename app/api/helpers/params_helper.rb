module ParamsHelper
  extend Grape::API::Helpers

  def declared_params(include_missing = true)
    declared(params, include_missing: include_missing)
  end

  def merged_params(include_missing = true)
    result = merge_access_token(declared_params(include_missing))
    merge_client_version(result)
  end

  def merge_access_token(params)
    params.merge(access_token: @current_token.token)
  end

  def merge_client_version(params)
    (params.merge(client_version: headers['Client-Version']) unless headers['Client-Version'].nil?) || params
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
