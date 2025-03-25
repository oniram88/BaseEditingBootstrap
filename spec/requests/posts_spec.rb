require 'rails_helper'

RSpec.describe "Posts", type: :request do
  include ActionView::RecordIdentifier

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

    describe "sorting" do
      let!(:posts) {
        create(:post, title: "Post 1")
        create(:post, title: "Post 2")
        create(:post, title: "Post 3")
      }
      it "headers" do
        get posts_path
        expect(response.body).to have_tag("tr>th>a", seen: "Titolo", with: {
          href: controller.view_context.sort_url(Post.ransack, :title)
        })

        expect(response.body).to have_tag("tr>th", seen: "Desc")
        expect(response.body).not_to have_tag("tr>th>a", seen: "Desc")
      end

      it "ordered list" do
        get posts_path, params: {q: {s: "title desc"}}
        expect(response.body).to have_tag("tbody>tr:first-child>td", text: "Post 3")
        get posts_path, params: {q: {s: "title asc"}}
        expect(response.body).to have_tag("tbody>tr:first-child>td", text: "Post 1")
      end

      it "sorting instance defaults sort and distinct" do
        get posts_path
        expect(assigns(:search_instance)).to have_attributes(
                                               sorts: ["id"],
                                               distinct: true
                                             )
      end

      it "sorting instance overrides sort and distinct" do
        get customer_posts_path
        expect(assigns(:search_instance)).to have_attributes(
                                               sorts: ["title"],
                                               distinct: false
                                             )
      end

    end

    describe "pagination" do

      let!(:posts) {
        create_list(:post, 30, title: "Post 1")
      }

      it "render pagination" do
        get posts_path
        expect(response.body).to have_tag("nav ul.pagination") do
          with_tag("li.page-item.active>a", text: "1")
          with_tag("li.page-item>a", text: "2")
        end
      end

    end

    describe "form" do

      subject {
        get new_post_path
        response.body
      }

      it "render form" do
        is_expected.to have_tag("form[action='#{posts_path}'][method='post']") do
          with_tag(".form-title-input-group") do
            with_tag("#post_title[type='text']")
          end
          with_tag(".form-published_at-input-group") do
            with_tag("#post_published_at[type='date']")
          end
          with_tag(".form-description-input-group") do
            with_tag("textarea#post_description")
          end
          with_tag(".form-category-input-group") do
            with_tag("select#post_category") do
              with_tag("option", count: 3)
            end
          end
        end
      end

      it "render special addons" do
        is_expected.to have_tag(".form-priority-input-group") do
          with_tag(".input-group-text", text: "priority unit")
          with_tag("select#post_priority") do
            with_tag("option", count: 3)
          end
        end
      end
      it "render help_text" do
        is_expected.to have_tag(".form-text", text: "Priority Helper text")
      end

      it "render help_text_html" do
        is_expected.to have_tag(".form-text", seen: "Helper con html") do
          with_tag(:b, seen: "html")
        end
      end

      it "render standard form classes" do
        is_expected.to have_tag(".input-group.mb-1", count: 7)
      end

      describe "inheritted models" do
        subject {
          get new_red_post_path
          response.body
        }

        it "render form" do
          is_expected.to have_tag("form[action='#{red_posts_path}'][method='post']") do

            # inheritted from standard post
            with_tag(".form-description-input-group") do
              with_tag("textarea#red_post_description")
            end

          end
        end

      end

    end

    describe "object validated" do

      let(:post_obj) { create(:post) }

      describe "rendered" do
        subject {
          put post_path(post_obj), params: {post: {title: nil}}
          response.body
        }
        it "render validations" do
          is_expected.to have_tag(".has-validation.form-title-input-group") do
            with_tag(".invalid-feedback")
          end
        end
      end

      context "with image" do
        let(:post_obj) { create(:post, :with_primary_image) }
        it "render primary_image" do
          put post_path(post_obj), params: {post: {title: nil}}

          expect(response.body).to have_tag("div##{dom_id(post_obj, "preview_image_primary_image")}", count: 1) do
            with_tag(:img)
          end

        end
      end

    end

  end

end
