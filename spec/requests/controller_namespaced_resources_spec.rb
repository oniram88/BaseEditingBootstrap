require 'rails_helper'

RSpec.describe "Controller Namespaced Class", type: :request do
  it_behaves_like "as logged in user" do

    describe "namespaced resources with namespaced model" do
      let(:post) { create(:post) }
      it "get correct namespaced class" do
        get customer_post_path(post.id)
        expect(assigns(:object)).to be_an_instance_of(Customer::Post)
        expect(response.body).to have_tag(:span, text: /this_is_special_method_for_customer_post/)
      end

    end

    describe "namespaced resources withouth namespaced model" do
      it "get correct class" do
        get customer_users_path()
        expect(response).to have_http_status(:ok)
        expect(assigns(:_base_class)).to be == User
      end
    end


  end

end
