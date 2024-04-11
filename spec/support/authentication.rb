



RSpec.shared_context "as logged in user" do
  let(:user) { create(:user) }
  before {
    user #così sono sicuro di generarlo
  }
end