class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :first_name, type: String
  field :last_name, type: String

  def initialize(first_name: '', last_name: '', dob: nil)
    @first_name = first_name
    @last_name = last_name
    @dob = dob
  end
end
