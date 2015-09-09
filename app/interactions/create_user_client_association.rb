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
    access_token = Oauth::BaseTokenGenerator.build_access_token_for(user, client.id)
    add_access_token_to_user(access_token, client)
    create_association(access_token)
  end

  def add_access_token_to_user(access_token, client)
    access_token.scopes = client.scopes.map(&:key)
    access_token.save
  end

  def create_association(access_token)
    UserClientAssociation.create(user: user, client: client) do |assoc|
      assoc.scopes = client.scopes.map(&:key)
      assoc.access_token = access_token.clone
    end
  end
end
