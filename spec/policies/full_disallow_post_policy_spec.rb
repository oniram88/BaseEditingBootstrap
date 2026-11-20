require 'rails_helper'

RSpec.describe FullDisallowPostPolicy, type: :policy do
  it_behaves_like "a standard base model policy", :red_post, check_default_responses: :full_disallow
end
