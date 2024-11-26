# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Utilities::SearchHelper, type: :helper do

  describe "#render_cell_field" do

    context "post model" do
      let(:obj) { create(:post, title: "Titolo", description: "desc") }

      it "with base rendering" do
        expect(helper.render_cell_field(obj, :title)).to have_tag(:td, text: "Titolo")
      end

      it "with timestamps rendering" do
        expect(helper.render_cell_field(obj, :created_at)).to have_tag(:td, text: I18n.l(obj.created_at, format: :long))
      end

      it "with specific rendering" do
        expect(helper.render_cell_field(obj, :description)).to have_tag(:td) do
          with_tag(:strong, text: "OVERRIDEN")
          with_tag(:p, text: "DESC")
        end
      end

      it "virtual attribute" do
        expect(obj).to respond_to(:custom_virtual_attribute)
        expect(obj.send(:custom_virtual_attribute)).to be == "content from virtual attribute"
        expect(helper.render_cell_field(obj, :custom_virtual_attribute)).to have_tag(:td, seen: "content from virtual attribute")
      end

    end

    context "user model" do
      let(:enabled) { nil }
      let(:obj) { create(:user, username: "dan_osman", enabled:) }

      it "with override base" do
        expect(helper.render_cell_field(obj, :username)).to have_tag(:td, with: {class: "override"}, text: "dan_osman")
      end

      describe "boolean field" do
        it "with default boolean" do
          expect(helper.render_cell_field(obj, :enabled)).to have_tag(:td) do
            with_tag("i.bi-x-lg.text-danger")
          end
        end
        context "with enabled true" do
          let(:enabled) { true }
          it "render ok" do
            expect(helper.render_cell_field(obj, :enabled)).to have_tag(:td) do
              with_tag("i.bi-check-lg.text-success")
            end
          end
        end
      end

      it "with override timestamp" do
        expect(helper.render_cell_field(obj, :created_at)).to have_tag(:td, text: Date.today.strftime("%d/%m/%Y"))
      end

    end

  end
end