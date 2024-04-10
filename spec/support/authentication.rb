default_unathorized_failure = -> { raise "TODO - passare proc con richiesta che dovrà fallire" }

RSpec.shared_examples "fail with unauthorized" do |request: default_unathorized_failure|
  it "expect to redirect to root" do
    expect(Pundit).to receive(:authorize).with(user, any_args).and_raise(Pundit::NotAuthorizedError)
    instance_exec(&request)
    expect(response).to redirect_to(root_path)
    expect(flash[:error]).not_to be_nil
  end
end



RSpec.shared_context "as logged in user" do
  let(:user) { create(:user) }
  before {
    user #così sono sicuro di generarlo
  }
end