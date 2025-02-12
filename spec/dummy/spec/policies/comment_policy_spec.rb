require 'rails_helper'
RSpec.describe CommentPolicy, type: :policy do
    it_behaves_like "a standard base model policy", :comment

end