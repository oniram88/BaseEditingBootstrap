require 'rails_helper'

RSpec.describe "Polimorphic Form", type: :request do
  include ActionView::RecordIdentifier

  it_behaves_like "as logged in user" do
    let(:user) { create(:user) }
    describe "form" do

      subject {
        get new_comment_path
        response.body
      }

      it "render form" do
        is_expected.to have_tag("form[action='#{comments_path}'][method='post']") do
          # NON gestiamo i polymorfici
          with_tag("input#comment_commentable[type='text']")
        end
      end

    end

  end

end
