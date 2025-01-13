# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Utilities::FormHelper, type: :helper do

  it "#editing_form_print_field" do
    expect(helper).to receive(:form_print_field).with("a", "b")
    helper.editing_form_print_field("a", "b")
  end

  describe "#form_print_field" do

    let(:form) {
      out = nil
      helper.form_for(obj, url: "#", builder: BaseEditingBootstrap::Forms::Base) do |f|
        out = f
      end
      out
    }
    context "post model" do
      let(:obj) { create(:post,
                         title: "Titolo",
                         description: "desc") }

      it "with base rendering" do
        expect(helper.form_print_field(form, :title)).to have_tag(:input, with: {class: "form-control", type: "text", name: "post[title]"})
      end

      it "with timestamps rendering" do
        expect(helper.form_print_field(form, :created_at)).to have_tag(:input, with: {class: "form-control", type: "datetime-local", name: "post[created_at]"})
      end

      it "with specific rendering" do
        expect(helper.form_print_field(form, :description)).to have_tag(:textarea, with: {class: "form-control", name: "post[description]"})
      end

      it "decimal_test_number" do
        expect(helper.form_print_field(form, :decimal_test_number)).to have_tag(:input, with: {type: "number", step: "0.001"})
      end
      it "rating" do
        expect(helper.form_print_field(form, :rating)).to have_tag(:input, with: {type: "number", step: "0.01"})
      end
      it "published_at" do
        expect(helper.form_print_field(form, :published_at)).to have_tag(:input, with: {type: "date"})
      end
      it "read_counter" do
        expect(helper.form_print_field(form, :read_counter)).to have_tag(:input, with: {type: "number", step: "1"})
      end

      describe "enum" do
        it "as string enum" do
          expect(helper.form_print_field(form, :category)).to have_tag(:select) do
            with_tag(:option, text: "News", with: {value: "news"})
          end
        end
        it "as integer" do
          expect(helper.form_print_field(form, :priority)).to have_tag(:select) do
            with_tag(:option, text: "Normal", with: {value: "normal"})
            with_tag(:option, text: "Low", with: {value: "low"})
            with_tag(:option, text: "Urgent", with: {value: "urgent"})
          end
        end
      end

      describe "has_one_attached" do

        subject { helper.form_print_field(form, :primary_image) }

        it "rendered when empty" do

          is_expected.to have_tag(:input, with: {type: "file"})
          is_expected.not_to have_tag(:input, with: {type: "hidden", name: "post[primary_image]"})
          is_expected.not_to have_tag(:button)

          expect(helper.content_for?(:form_field_ending)).to be_falsey
        end

        context "with an attached image" do
          let(:obj) { create(:post, :with_primary_image) }

          it do
            is_expected.to have_tag(:input, with: {type: "hidden", name: "post[primary_image]", value: obj.primary_image.signed_id})
            is_expected.to have_tag(:button) do
              with_tag("i.bi-trash")
            end
            is_expected.to have_tag(:span, seen: obj.primary_image.attachment.blob.filename)
            is_expected.to have_tag(:a, with: {href: url_for(obj.primary_image), target: "_blank"})
            expect(helper.content_for(:form_field_ending)).to have_tag(:div) do
              with_tag(:img)
            end

          end

        end

        context "with an attached file not representable?" do
          let(:obj) { create(:post, :with_text_file) }

          it do
            is_expected.to have_tag(:input, with: {type: "hidden", name: "post[primary_image]", value: obj.primary_image.signed_id})
            is_expected.to have_tag(:button) do
              with_tag("i.bi-trash")
            end
            is_expected.to have_tag(:span, seen: obj.primary_image.attachment.blob.filename)
            is_expected.to have_tag(:a, with: {href: url_for(obj.primary_image), target: "_blank"})
            expect(helper.content_for?(:form_field_ending)).to be_falsey

          end

        end

      end

    end

    context "user model" do
      let(:obj) { create(:user, username: "dan_osman") }

      it "with override base" do
        expect(helper.form_print_field(form, :username)).to have_tag(:input, with: {class: "form-control override", type: "text", name: "user[username]"})
      end

      it "with default boolean" do
        expect(helper.form_print_field(form, :enabled)).to have_tag(".form-check.form-switch") do
          with_tag("input[type='hidden']", with: {value: 0})
          with_tag("input.form-check-input[type='checkbox']", with: {value: 1})
          with_tag("label.form-check-label", with: {for: "user_enabled"})
        end
      end

      it "with override timestamp" do
        expect(helper.form_print_field(form, :created_at)).to have_tag(:input, with: {class: "form-control", type: "datetime-local", name: "user[created_at]"})
      end

    end

    context "ActionModel" do
      let(:obj) {

        a = Class.new do
          include ActiveModel::API

          def self.name = "nome_classe"

          attr_accessor :example_field
        end

        a.new
      }

      it "render standard fields as text" do
        expect(helper.form_print_field(form, :example_field)).to have_tag(:input, with: {class: "form-control", type: "text", name: "nome_classe[example_field]"})
      end

    end

  end
end