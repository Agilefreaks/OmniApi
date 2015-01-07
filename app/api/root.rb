module API
  # helpers
  require 'helpers/authentication_helper'
  require 'helpers/params_helper'
  require 'helpers/track_helper'

  require 'root_v1'

  class Root < Grape::API
    format :json
    content_type :json, 'application/json'

    rescue_from Mongoid::Errors::DocumentNotFound do
      rack_response({ error: { message: "We didn't find what we were looking for" } }.to_json, 404)
    end

    helpers AuthenticationHelper
    helpers ParamsHelper
    helpers TrackHelper

    mount RootV1 => '/api/v1'
  end
end
