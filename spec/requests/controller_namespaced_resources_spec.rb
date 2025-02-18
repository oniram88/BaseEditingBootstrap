require 'rails_helper'

RSpec.describe "Controller Namespaced Class", type: :request do
  it_behaves_like "as logged in user" do

    describe "namespaced resources with namespaced model" do
      let!(:post) { create(:post) }
      it "get correct namespaced class" do
        get customer_post_path(post.id)
        expect(assigns(:object)).to be_an_instance_of(Customer::Post)
        expect(response.body).to have_tag(:span, text: /this_is_special_method_for_customer_post/)
      end

      it "index with override custom template from super class model" do

        get customer_posts_path
        expect(response.body).to have_tag(:td) do
          with_tag(:strong,text:"OVERRIDEN")
        end

      end

    end

    describe "check sorts and distinct" do
      it_behaves_like "base editing controller", factory: :post, only: [:index] do
        let(:url_for_index) { customer_posts_path }
        let(:default_sorts) { ["title"] }
        let(:default_distinct) { false }
      end
    end

    describe "namespaced resources withouth namespaced model" do
      it "get correct class" do
        get customer_users_path()
        expect(response).to have_http_status(:ok)
        expect(assigns(:_base_class)).to be == User
      end
    end

    describe "namespaced resources with custom form fields" do
      let(:post) { create(:post) }
      it "get correct field override" do
        get edit_customer_post_path(post)

        expect(response.body).to have_tag(:span, seen: "OVERRIDE for title")

      end
    end

  end

end
