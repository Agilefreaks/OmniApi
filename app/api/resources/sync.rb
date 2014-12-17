module API
  module Resources
    class Sync < Grape::API
      resource :sync do
        before do
          authenticate!
        end

        desc 'Create a sync request', ParamsHelper.omni_headers
        params do
          optional :what, type: Symbol, values: [:contacts, :other], desc: 'What to sync?'
          optional :identifier, type: String, desc: 'The source device identifier.'
        end
        post do
          NotificationService.new.notify(ContactList.new(user: @current_user), declared_params[:identifier])
          body(false)
        end
      end
    end
  end
end
