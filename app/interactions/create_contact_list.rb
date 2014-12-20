class CreateContactList
  def self.with(params)
    CreateContactList.new(params).create
  end

  attr_reader :access_token, :contacts, :identifier, :source_identifier
  attr_accessor :contact_list_builder, :notification_service

  def initialize(params)
    @access_token = params[:access_token]
    @contacts = params[:contacts]
    @identifier = params[:identifier]
    @source_identifier =  params[:source_identifier]
  end

  def create
    @contact_list_builder ||= ContactListBuilder.new
    @notification_service ||= NotificationService.new

    contact_list = @contact_list_builder.build(@access_token, @identifier, @contacts)
    @notification_service.notify(contact_list, @source_identifier)

    contact_list
  end
end
