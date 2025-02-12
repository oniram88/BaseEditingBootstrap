require 'rails_helper'
RSpec.describe Comment, type: :model do
  it_behaves_like "a base model",
                  ransack_permitted_attributes: %w[comment commentable_id]

 # it_behaves_like "a base model",
 #                 ransack_permitted_attributes: %w[comment commentable_id],
 #                 ransack_permitted_associations: [],
 #                 option_label_method: :to_s,
 #                 ransack_permitted_scopes: []  do
 #     let(:auth_object) { :auth_object } <- default
 #     let(:auth_object) { create(:user, :as_admin) } <- in caso di necessità di override
 #     let(:new_user_ransack_permitted_attributes) { ransack_permitted_attributes }
 #     let(:new_user_ransack_permitted_associations) { ransack_permitted_associations }
 #     let(:new_user_ransack_permitted_scopes) { ransack_permitted_scopes }
 # end

end