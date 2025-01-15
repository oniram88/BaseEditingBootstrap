RSpec.shared_context "as logged in user" do
  let(:user) { create(:user) }
  before {
    user # così sono sicuro di generarlo
  }
end

module SimulatedCurrentUser
  def current_user
    @current_user ||= User.new
  end
end
module SimulatedCurrentUserHelper

  def self.included(base)
    base.described_class.include SimulatedCurrentUser
    super
  end
end

RSpec.configure do |config|
  config.include SimulatedCurrentUserHelper, type: :helper
end
