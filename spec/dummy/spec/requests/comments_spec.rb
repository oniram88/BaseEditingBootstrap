require 'rails_helper'
RSpec.describe "Comments", type: :request do
  it_behaves_like "as logged in user" do
    it_behaves_like "base editing controller", factory: :comment
  end
end