class UpdateContact
  def self.with(params)
    UpdateContact.new(params).update
  end

  attr_reader :access_token, :id, :update_params

  def initialize(params)
    @access_token = params.delete(:access_token)
    @id = params.delete(:id)
    @update_params = params
  end

  def update
    contact = FindContacts.for(@access_token, id: @id)
    contact.update_attributes(@update_params)

    NotificationService.new.contact_updated(contact, @update_params[:device_id])

    contact
  end
end
