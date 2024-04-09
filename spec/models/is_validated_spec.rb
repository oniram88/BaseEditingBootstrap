require "rails_helper"

RSpec.describe "A validated model" do
  it_behaves_like "a validated? object" do
    subject {
      # prendiamo un modello a caso per testare questa  cosa
      User.new
    }
  end
end
