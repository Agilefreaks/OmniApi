module API
  # resources
  require 'resources/v2/devices'

  class RootV2 < Grape::API
    mount Resources::V2::Devices

    base_paths = {
      'development' => 'http://localhost:9292',
      'staging' => 'https://apistaging.omnipasteapp.com'
    }

    add_swagger_documentation(
      api_version: 'v2',
      mount_path: 'doc',
      hide_documentation_path: true,
      base_path: base_paths[ENV['RACK_ENV']]
    )
  end
end
