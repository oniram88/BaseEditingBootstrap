require 'rails_helper'

RSpec.describe "translate_with_controller_scoped", type: :request do
  it_behaves_like "as logged in user" do

    describe "No translation overrides" do
      subject {
        get users_path
        response.body
      }
      let!(:user) { create(:user) }
      it {
        is_expected.to have_tag(:a, with: {href: edit_user_path(user)}, seen: "Modifica")
      }
      it {
        is_expected.to have_tag(:a, with: {href: user_path(user)}, seen: "")
      }
    end

    describe "Translation overrides for Post Controller" do
      let!(:post) { create(:post) }
      subject {
        get posts_path
        response.body
      }
      it { is_expected.to have_tag(:a, with: {href: edit_post_path(post)}, seen: "MOD Post") }
      it { is_expected.to have_tag(:a, with: {href: post_path(post)}, seen: "Show Post Inherited") }

      context "Overrides in Customer" do
        let!(:post) { create(:customer_post) }
 subject {
        get customer_posts_path
        response.body
      }
        it { is_expected.to have_tag(:a, with: {href: edit_customer_post_path(post)}, seen: "Customer Mod Post") }
        it { is_expected.to have_tag(:a, with: {href: customer_post_path(post)}, seen: "Show Post Inherited") }

      end

    end

  end

end
