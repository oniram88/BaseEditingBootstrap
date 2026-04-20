# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Utilities::FormHelper, type: :helper do

  it "#editing_form_print_field" do
    expect(helper).to receive(:form_print_field).with("a", "b")
    helper.editing_form_print_field("a", "b")
  end

  describe "#form_print_field_object" do
    let(:form) { double("form", object: double("object")) }
    let(:field) { "name" }

    it "creates a FieldRenderer instance with correct parameters" do
      renderer = helper.form_print_field_object(form, field)
      expect(renderer).to be_a(BaseEditingBootstrap::Forms::FieldRenderer)
      expect(renderer.form).to eq(form)
      expect(renderer.field).to eq(field)
    end

    it "passes readonly option to FieldRenderer" do
      renderer = helper.form_print_field_object(form, field, readonly: true)
      expect(renderer).to be_a(BaseEditingBootstrap::Forms::FieldRenderer)
      expect(renderer.readonly_value).to eq(true)
    end
  end

  describe "#form_print_field" do
    let(:form) { double("form", object: double("object")) }
    let(:field) { "name" }
    let(:renderer) { instance_double(BaseEditingBootstrap::Forms::FieldRenderer) }

    it "renders the form field using FieldRenderer" do
      allow(helper).to receive(:form_print_field_object).with(form, field).and_return(renderer)
      expect(renderer).to receive(:render).and_return("rendered content")

      result = helper.form_print_field(form, field)
      expect(result).to eq("rendered content")
    end

    it "renders the form field with readonly option" do
      allow(helper).to receive(:form_print_field_object).with(form, field, readonly: true).and_return(renderer)
      expect(renderer).to receive(:render).and_return("readonly content")

      result = helper.form_print_field(form, field, readonly: true)
      expect(result).to eq("readonly content")
    end
  end
end