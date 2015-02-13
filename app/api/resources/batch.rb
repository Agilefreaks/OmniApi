module API
  module Resources
    class Batch < Grape::API
      resource :batch do
        post do
          Grape::Batch::Base.new(OmniApi::App.instance).batch_call(env)
          # send batch notification
        end
      end
    end
  end
end
