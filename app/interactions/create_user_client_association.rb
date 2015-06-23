class CreateUserClientAssociation
  def self.between(user, client)
    CreateUserClientAssociation.new(user, client).create
  end

  attr_reader :user, :client

  def initialize(user, client)
    @user = user
    @client = client
  end

  def create
    UserClientAssociation.create({user: user, client: client})
  end
end
