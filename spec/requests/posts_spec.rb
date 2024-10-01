require 'rails_helper'

RSpec.describe "Posts", type: :request do
  it_behaves_like "as logged in user" do
    let(:user) { create(:user) }
    it_behaves_like "base editing controller", factory: :post

    context "configuration to redirect to index action" do
      around do |example|
        BaseEditingBootstrap.configure do |config|
          config.after_success_update_redirect = :index
          config.after_success_create_redirect = :index
        end
        example.run
        BaseEditingBootstrap.configure do |config|
          config.after_success_update_redirect = :edit
          config.after_success_create_redirect = :edit
        end
      end
      it_behaves_like "base editing controller", factory: :post

    end

    describe "search" do
      let!(:posts) {
        create(:post, title: "Post 1")
        create(:post, title: "Post 2")
        create(:post, title: "Post 3")
      }

      it "index rendered with search form" do

        get posts_path
        expect(assigns(:search_instance)).to be_an_instance_of(BaseEditingBootstrap::Searches::Base).
          and(
            have_attributes(
              user: user,
              sorts: ["id"]
            )
          )
        expect(response.body).to have_tag("form.post_search") do
          with_tag(:input, with: {name: "q[title_i_cont]"})
          with_tag(:a, with: {href: posts_path})
        end
        expect(response.body).to have_tag("table.search_results_post>tbody>tr", count: 3)

      end

      it "get results" do
        get posts_path, params: {q: {title_i_cont: "post 1"}}
        expect(response.body).to have_tag("tr>td", text: "Post 1")
      end

    end

    describe "pagination" do

      let!(:posts) {
        create_list(:post, 30, title: "Post 1")
      }

      it "render pagination" do
        get posts_path
        expect(response.body).to have_tag("nav ul.pagination") do
          with_tag("li.page-item.active>a",text: "1")
          with_tag("li.page-item>a",text: "2")
        end
      end

    end

    describe "form" do

      subject {
        get new_post_path
        response.body
      }

      it "render form" do
        is_expected.to have_tag("form[action='#{posts_path}'][method='post']")
      end

      it "render special addons" do
        is_expected.to have_tag(".form-text", text: "Priority Helper text")
        is_expected.to have_tag(".input-group-text", text: "priority unit")
      end

    end

  end

end
