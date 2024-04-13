# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Utilities::FormHelper, type: :helper do

  it "#editing_form_print_field" do
    expect(helper).to receive(:form_print_field).with("a","b")
    helper.editing_form_print_field("a","b")
  end

  describe "#form_print_field" do

    let(:form) {
      out = nil
      helper.form_for(obj,url:"#") do |f|
        out = f
      end
      out
    }
    context "post model" do
      let(:obj) { create(:post, title: "Titolo", description: "desc") }

      it "with base rendering" do
        expect(helper.form_print_field(form, :title)).to have_tag(:input, with: {class: "form-control", type: "text", name: "post[title]"})
      end

      it "with timestamps rendering" do
        expect(helper.form_print_field(form, :created_at)).to have_tag(:input, with: {class: "form-control", type: "datetime-local", name: "post[created_at]"})
      end

      it "with specific rendering" do
        expect(helper.form_print_field(form, :description)).to have_tag(:textarea, with: {class: "form-control", name: "post[description]"})
      end
    end

    context "user model" do
      let(:obj) { create(:user, username: "dan_osman") }

      it "with override base" do
        expect(helper.form_print_field(form, :username)).to have_tag(:input, with: {class: "form-control override", type: "text", name: "user[username]"})
      end

      it "with override timestamp" do
        expect(helper.form_print_field(form, :created_at)).to have_tag(:input, with: {class: "form-control", type: "date", name: "user[created_at]"})
      end

    end

  end
end