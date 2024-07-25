require 'rails_helper'

RSpec.describe "Customer::Posts", type: :request do
  it_behaves_like "as logged in user" do
    let(:user) { create(:user) }
    it_behaves_like "base editing controller", factory: :post


    describe "show" do
      let(:post) { create(:post) }
      it "get" do
        get customer_post_path(post.id)
        expect(assigns(:object)).to be_an_instance_of(Customer::Post)
        expect(response.body).to have_tag(:span, text: /this_is_special_method_for_customer_post/)
      end

    end


  end

end
