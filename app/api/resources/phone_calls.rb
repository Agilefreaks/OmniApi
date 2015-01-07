module API
  module Resources
    class PhoneCalls < Grape::API
      resources :phone_calls do
        before do
          authenticate!
        end

        after do
          TrackHelper.track
        end
      end
    end
  end
end