require 'rails_helper'

RSpec.describe PostPolicy, type: :policy do
  it_behaves_like "a standard policy", :post
end
