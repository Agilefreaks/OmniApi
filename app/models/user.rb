class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :first_name, type: String
  field :last_name, type: String

  embeds_many :access_tokens
  embeds_many :authorization_codes

  index({ 'authorization_codes.code' => 1 }, { unique: true })

  def self.find_by_code(code)
    User.where('authorization_codes.code' => code).first
  end
end
