# frozen_string_literal: true

RSpec.describe BaseEditingBootstrap do
  it "has a version number" do
    expect(BaseEditingBootstrap::VERSION).not_to match /[0-9]+\.[0-9]+\.[0-9]+\]/
  end

  describe "configurations" do
    where(:config) do
      [
        [:inherited_controller],
        [:after_success_update_redirect],
        [:after_success_create_redirect],
      ]
    end

    with_them do
      it "should " do
        expect(BaseEditingBootstrap).to respond_to(config)
      end
    end
  end
end
