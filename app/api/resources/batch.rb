module API
  module Resources
    class Batch < Grape::API
      resource :batch do
        before do
          env['HTTP_NO_NOTIFICATION'] = false
          authenticate!
        end

        after do
          NotificationService.new.contacts_updated(OpenStruct.new(user: @current_user), nil)
        end

        post do
          Grape::Batch::Base.new(OmniApi::App.instance).batch_call(env)
        end
      end
    end
  end
end
