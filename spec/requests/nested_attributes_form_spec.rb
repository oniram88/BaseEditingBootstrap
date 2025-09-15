require 'rails_helper'

RSpec.describe "Nested Attributes Form", type: :request do
  include ActionView::RecordIdentifier

  it_behaves_like "as logged in user" do
    let(:user) { create(:user) }
    describe "form" do

      subject {
        get new_company_path
        response.body
      }

      it "render form for without nested elements" do
        is_expected.to have_tag("form[action='#{companies_path}'][method='post']") do

          with_tag(:table,
                   with: {
                     class: "table",
                     "data-controller": "nested-form"
                   }
          ) do

            # header
            with_tag("thead>tr>th", seen: "Street")
            with_tag("thead>tr>th", seen: "Cap")
            with_tag("thead>tr>th", seen: "City")
            with_tag("thead>tr>th>button", with: {"data-action": "nested-form#add"})

            # template for adds
            with_tag("template", with: {"data-nested-form-target": "template"}) do
              with_tag("tr.nested-form-wrapper#new_address", with: {"data-new-record" => "true"})

              [:street, :cap, :city].each do |field|
                with_tag("td>input", with: {type: "text", name: "company[addresses_attributes][NEW_RECORD][#{field}]"})
              end

              with_tag("td>button", with: {"data-action": "nested-form#remove"})
              with_tag("td>input", with: {"name": "company[addresses_attributes][NEW_RECORD][_destroy]", type: "hidden", value: "false"})

            end

            # Body
            with_tag("tbody>tr", count: 1)
            with_tag("tbody>tr", with: {"data-nested-form-target" => "target"})

          end

        end
      end

      it "render form with has_one nested element initialized" do
        expect {
          is_expected.to have_tag("form[action='#{companies_path}'][method='post']") do
            with_tag(".form-comment-input-group") do
              with_tag("textarea", with: {name: "company[comment_attributes][comment]"})
            end
          end
        }.not_to change(Comment, :count)
      end

      context "with nested elements" do
        let(:address) { create(:address) }
        let(:company) { address.company }

        subject {
          get edit_company_path(company)
          response.body
        }
        it "render form for with nested elements" do
          is_expected.to have_tag("form[action='#{company_path(company)}'][method='post']") do
            with_tag(:table,
                     with: {
                       class: "table",
                       "data-controller": "nested-form"
                     }
            ) do
              # Body
              with_tag("tbody>tr", count: 2)

              with_tag("tbody>tr") do

                [:street, :cap, :city].each do |field|
                  with_tag("td>input", with: {type: "text", name: "company[addresses_attributes][0][#{field}]"})
                end

              end
              with_tag("input", with: {type: "hidden", name: "company[addresses_attributes][0][id]", value: address.id})

            end
          end
        end

        context "with comment on company" do
          let!(:comment) {
            create(:comment, commentable: company, comment: "COMMENTO da VISUALIZZARE")
          }

          it do
            is_expected.to have_tag(".form-comment-input-group") do
              with_tag("textarea", with: {name: "company[comment_attributes][comment]"},seen: comment.comment)
            end
          end

        end

      end

    end

    describe "errors on row nested attribute" do

      subject {
        post companies_path, params: {company: {name: "example", addresses_attributes: [{city: "Brescia"}]}}
        response.body
      }

      it "is expected to rendere error in correct cell" do
        is_expected.to have_tag("tr#new_address>td") do
          with_tag("input.is-invalid", with: {type: "text", name: "company[addresses_attributes][0][street]"})
          with_tag(".invalid-feedback", seen: "Street non può essere lasciato in bianco")
        end
      end

    end

    describe "errors on base nested attribute" do
      subject {
        post companies_path, params: {company: {name: "example",
                                                addresses_attributes: [
                                                  {city: "Brescia"},
                                                  {city: "Bergamo"},
                                                  {city: "Desenzano"}
                                                ]}}
        response.body
      }

      it "is expected to rendere general error at bottom of table" do
        is_expected.to have_tag(".row>.col-12>.alert.alert-danger", seen: "TOO MANY ADDRESSES, Other Error")
      end

    end

  end

end
