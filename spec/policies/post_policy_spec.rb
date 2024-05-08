require 'rails_helper'

RSpec.describe PostPolicy, type: :policy do
  it_behaves_like "a standard base model policy", :post, check_default_responses: true
end
