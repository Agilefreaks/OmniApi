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
    (@contact_builder ||= ContactBuilder.new).build(access_token, params)
  end
end
