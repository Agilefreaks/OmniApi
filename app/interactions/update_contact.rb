class UpdateContact
  def self.with(params)
    UpdateContact.new(params).update
  end

  attr_reader :access_token, :id, :update_params

  def initialize(params)
    @access_token = params.delete(:access_token)
    @id = params.delete(:id)
    @update_attributes = params
  end

  def update
    contact = FindContacts.for(@access_token, id: @id)
    contact.update_attributes(@update_attributes)
    User.find_by_token(access_token).update_attribute(:contacts_updated_at, Time.now.utc)
    NotificationService.new.contact_updated(contact, @update_attributes[:device_id])

    contact
  end
end
