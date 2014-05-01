module API
  module Resources
    class Notifications < Grape::API
      resources :notifications do
        post '/' do
        end
      end
    end
  end
end