require 'rails_helper'

RSpec.describe "Posts", type: :request do
  it_behaves_like "as logged in user" do
    let(:user) { create(:user) }
    it_behaves_like "base editing controller", factory: :post

    describe "search" do
      let!(:posts) {
        create(:post, title: "Post 1")
        create(:post, title: "Post 2")
        create(:post, title: "Post 3")
      }

      it "index rendered with search form" do

        get posts_path
        expect(assigns(:search_instance)).to be_an_instance_of(BaseEditingBootstrap::Searches::Base)
        expect(response.body).to have_tag("form.post_search") do
          with_tag(:input, with: {name: "q[title_i_cont]"})
        end
        expect(response.body).to have_tag("table.search_results_post>tbody>tr", count: 3)

      end

      it "get results" do
        get posts_path, params: {q: {title_i_cont: "post 1"}}
        expect(response.body).to have_tag("tr>td", text: "Post 1")
      end

    end

  end

end
