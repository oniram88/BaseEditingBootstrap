# frozen_string_literal: true

RSpec.describe BaseEditingBootstrap do
  it "has a version number" do
    expect(BaseEditingBootstrap::VERSION).not_to be nil
  end
  describe "configuration" do
    it "get inherited controller" do
      expect(BaseEditingBootstrap.inherited_controller).to be == "ApplicationController"
    end
  end
end
