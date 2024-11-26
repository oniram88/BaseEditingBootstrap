require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  it_behaves_like "a standard base model policy", :user, check_default_responses: true do

    it "search results are the same as sortable search sesults" do
      expect(instance.search_result_fields).to match_array(instance.sortable_search_result_fields)
    end

  end

end
