require 'rails_helper'

RSpec.describe "Posts", type: :request do
  it_behaves_like "as logged in user" do
    let(:user) { create(:user) }

    describe "form" do

      before do
        create_list(:role, 5)
      end

      subject {
        get new_user_path
        response.body
      }

      it "render form" do
        is_expected.to have_tag("form[action='#{users_path}'][method='post']") do
          with_tag(".form-roles-input-group") do
            with_tag(".form-check", count: Role.count)
          end
          without_tag(".input-group.form-roles-input-group")
          with_tag(".form-enabled-input-group") do
            with_tag(".form-check.form-switch", count: 1) do
              with_tag("input[type='hidden']", with: {value: 0})
              with_tag("input.form-check-input[type='checkbox']", with: {value: 1})
            end
          end

        end
      end
    end

  end

end