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
    user_client_association = UserClientAssociation.new(user: user, client: client)
    user_client_association.scopes = client.scopes
    user_client_association.save!

    user_client_association
  end
end
