require 'rails_helper'

RSpec.describe "Base Errors", type: :request do
  include ActionView::RecordIdentifier

  it_behaves_like "as logged in user" do

    let(:instance) { create(:user) }
    let(:params) { {only_true_boolean: false} }

    subject {
      put polymorphic_path(instance), params: {instance.class.model_name.param_key => params}
      response.body
    }

    it "render form without base errors" do
      is_expected.to have_tag("form[action='#{user_path(instance)}'][method='post']") do
        without_tag("div.base-errors-container")
      end
    end

    context "with base errors" do
      let(:params) { super().merge(username: "BASE ERROR") }
      it "render form with base errors" do
        is_expected.to have_tag("form[action='#{user_path(instance)}'][method='post']") do
          with_tag("div.base-errors-container##{dom_id(instance, :base_errors_container)}") do
            with_tag(".card-header", seen: "Presenti errori generici")
            with_tag(:li, seen: "SIMULATE BASE ERROR")
          end
        end
      end

      context "customize title" do
        let(:instance) { create(:post) }
        let(:params) { {title: "BASE ERROR"} }
        it "render form with base errors" do
          is_expected.to have_tag("form[action='#{post_path(instance)}'][method='post']") do
            with_tag("div.base-errors-container##{dom_id(instance, :base_errors_container)}") do
              with_tag(".card-header", seen: "Presenti errori per il modello POST")
            end
          end
        end
      end

    end

  end
end