shared_context :with_authentificated_user do
  let(:current_user) { Fabricate(:user) }

  before(:each) do
    allow(User).to receive(:find_by_token).and_return(current_user)
  end
end