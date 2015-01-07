module API
  module Resources
    class Sync < Grape::API
      resource :sync do
        before do
          authenticate!
        end

        after do
          TrackHelper.track({ what: merged_params[:what] })
        end

        desc 'Create a sync request', ParamsHelper.omni_headers
        params do
          optional :what, type: Symbol, values: [:contacts, :other], desc: 'What to sync?'
          optional :identifier, type: String, desc: 'The source device identifier.'
        end
        post do
          contact_list = ContactList.new(user: @current_user, identifier: declared_params[:identifier])
          NotificationService.new.notify(contact_list, declared_params[:identifier])
          body(false)
        end
      end
    end
  end
end
