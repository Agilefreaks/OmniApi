module ParamsHelper
  extend Grape::API::Helpers

  def declared_params
    declared(params)
  end

  def merged_params
    declared_params.merge(access_token: @current_token.token)
  end

  def auth_headers
    {
      headers: {
        'Authorization' => {
          description: 'The authorization token.',
          required: true
        }
      }
    }
  end

  module_function :auth_headers
end
