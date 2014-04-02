module API
  module Resources
    class Version < Grape::API
      resource :version do
        get do
          Configuration.app_version
        end
      end
    end
  end
end
