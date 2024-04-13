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
    end

    context "user model" do
      let(:obj) { create(:user, username: "dan_osman") }

      it "with override base" do
        expect(helper.render_cell_field(obj, :username)).to have_tag(:td, with: {class: "override"}, text: "dan_osman")
      end

      it "with override timestamp" do
        expect(helper.render_cell_field(obj, :created_at)).to have_tag(:td, text: Date.today.strftime("%d/%m/%Y"))
      end

    end

  end
end