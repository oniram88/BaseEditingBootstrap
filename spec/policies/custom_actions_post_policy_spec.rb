require 'rails_helper'

RSpec.describe CustomActionsPostPolicy, type: :policy do

  it_behaves_like "a standard base model policy", :red_post, check_default_responses: {
    custom_action_one: true,
    custom_action_second: false
  }

end
