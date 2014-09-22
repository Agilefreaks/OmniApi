class GetAuthorizationCode
  class << self
    def for(email)
      GetAuthorizationCode.new.execute_with_access_token(email)
    end

    def for_emails(emails)
      GetAuthorizationCode.new.execute_with_emails(emails)
    end
  end

  def execute_with_access_token(email)
    user = User.find_by(email: email)

    fail Mongoid::Errors::DocumentNotFound.new(User, nil) unless user

    user.authorization_codes.first || user.authorization_codes.create
  end

  def execute_with_emails(emails)
    user = User.where(:email.in => emails, 'authorization_codes.active' => true).first
    user ? user.authorization_codes.first : EmptyAuthorizationCode.create(emails: emails)
  end
end
