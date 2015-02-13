class CreateContact
  def self.with(params)
    CreateContact.new(params).create
  end

  attr_accessor :contact_builder, :access_token, :params, :device_id, :no_notification

  def initialize(args)
    @access_token = args[:access_token]
    @device_id = args[:device_id]
    @no_notification = args[:no_notification]
    @params = args.slice(:contact_id, :first_name, :last_name, :phone_numbers, :image)
  end

  def create
    contact = (@contact_builder ||= ContactBuilder.new).build(access_token, params)
    User.find_by_token(access_token).update_attribute(:contacts_updated_at, Time.now.utc)
    NotificationService.new.contact_created(contact, @device_id) if contact.valid? && !no_notification
    contact
  end
end
