class CreateContact
  def self.with(params)
    CreateContact.new(params).create
  end

  attr_accessor :contact_builder, :access_token, :params

  def initialize(args)
    @access_token = args[:access_token]
    @params = args.slice(:contact_id, :first_name, :last_name, :phone_numbers, :image)
  end

  def create
    contact = (@contact_builder ||= ContactBuilder.new).build(access_token, params)
    User.find_by_token(access_token).update_attribute(:contacts_updated_at, Time.now.utc)
    contact
  end
end
