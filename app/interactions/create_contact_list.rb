class CreateContactList
  def self.with(params)
    CreateContactList.new(params).create
  end

  def initialize(_params)
  end
end
