module API
  # helpers
  require 'helpers/authentication_helper'
  require 'helpers/params_helper'
  require 'helpers/route_helper'

  require 'root_v1'
  require 'root_v2'

  class Root < Grape::API
    format :json
    content_type :json, 'application/json'

    rescue_from Mongoid::Errors::DocumentNotFound do
      rack_response({ error: { message: "We didn't find what we were looking for" } }.to_json, 404)
    end

    helpers AuthenticationHelper
    helpers ParamsHelper
    helpers RouteHelper

    mount RootV1 => '/api/v1'
    mount RootV2 => '/api/v2'
  end
end
