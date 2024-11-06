# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BaseEditingBootstrap::Forms::Base, :type => :helper do
  before do
    def helper.index_custom_polymorphic_path(*args)
      "link_ricevuto/da/controller"
    end
  end

  let(:object_instance) { User.new }

  let(:builder) {
    described_class.new(:user, object_instance, helper, {})
  }

  describe "override field helper for form-controll" do
    where(:field_helper, :tag, :more_attributes) do
      [
        [:text_field, :input, {}],
        [:password_field, :input, {type:"password"}],
        [:text_area, :textarea, {}],
        [:ckeditor_text_area, :textarea, {"data-controller": "ckeditor"}],
        [:date_field, :input, {}],
        [:datetime_field, :input, {}],
        [:time_field, :input, {}],
        [:file_field, :input, {}],
        [:number_field, :input, {}],
        [:decimal_field, :input, {step: "any", value: "0.0"}]
      ]
    end

    with_them do
      it {
        expect(builder.public_send(field_helper, :username)).to have_tag(
                                                                  tag,
                                                                  with: {class: "form-control"}.merge(more_attributes)
                                                                )
      }
      it "overrides class" do
        expect(builder.public_send(field_helper, :username, {class: "custom_class"})).to have_tag(
                                                                                          tag,
                                                                                          with: {class: "form-control custom_class"}.merge(more_attributes)
                                                                                        )
      end
      context "field not valid" do
        let(:object_instance) { super().tap { |u| u.errors.add(:username, :invalid) } }
        it {
          expect(builder.public_send(field_helper, :username)).to have_tag(
                                                                    tag,
                                                                    with: {class: "form-control is-invalid"}
                                                                  )
        }
      end
    end
  end

  describe "form_style_class_for" do
    it "default" do
      expect(builder.form_style_class_for(:username)).to be == "form-control"
    end
    it "with override" do
      expect(builder.form_style_class_for(:username, {class: "custom_class"})).to be == "form-control custom_class"
    end
    it "override with same" do
      expect(builder.form_style_class_for(:username, {class: "form-control custom_class"})).to be == "form-control custom_class"
    end
    context "with errors" do
      let(:object_instance) { super().tap { |u| u.errors.add(:username, :invalid) } }
      it "default" do
        expect(builder.form_style_class_for(:username)).to be == "form-control is-invalid"
      end
      it "with override" do
        expect(builder.form_style_class_for(:username, {class: "custom_class"})).to be == "form-control is-invalid custom_class"
      end
    end
  end

  describe "select" do
    it "" do
      expect(builder.select(:username, [])).to have_tag(
                                                 :select,
                                                 with: {class: "form-control form-select"}
                                               )
    end
    it "overrides class" do
      expect(builder.select(:username, [], {}, {class: "custom_class"})).to have_tag(
                                                                              :select,
                                                                              with: {class: "custom_class"}
                                                                            )
    end
  end

  describe "radio button" do
    it do
      expect(builder.radio_button(:username, 'yes')).to have_tag(
                                                          :div,
                                                          with: {class: "form-check"}
                                                        ) do
        with_tag(:input, with: {type: "radio", class: "form-check-input"})
        with_tag(:label, with: {class: "form-check-label"})
      end
    end
  end

  describe "check_box" do
    it do
      expect(builder.check_box(:username)).to have_tag(:div, with: {class: "form-check"}) do
        with_tag(:input, with: {type: "checkbox", class: "form-check-input"})
      end
      expect(builder.check_box(:username)).not_to have_tag("div.form-check label")
    end
    it "con label" do
      expect(builder.check_box(:username, label: "label name")).to have_tag(:div, with: {class: "form-check"}) do
        with_tag(:input, with: {type: "checkbox", class: "form-check-input"})
        with_tag(:label, text: "Label name", with: {class: "form-check-label"})
      end
    end
    it "con classe custom" do
      expect(builder.check_box(:username, class: "custom_class")).to have_tag(:div, with: {class: "form-check custom_class"})
    end
  end

  describe "switch_box" do
    it do
      expect(builder).to receive(:check_box).with(:username, include(class: "form-switch"), "1", "0")
      builder.switch_box(:username)
    end
    it "con classe custom" do
      expect(builder).to receive(:check_box).with(:username, include(class: "form-switch custom_class"), "1", "0")
      builder.switch_box(:username, class: "custom_class")
    end
  end

  describe "collection_check_boxes" do
    let(:list) { create_list(:post, 5) }
    it do
      rendered = builder.collection_check_boxes(:posts, list, :id, :title)
      expect(rendered).to have_tag("div.form-check", count: 5) do
        with_tag(:input, with: {type: "checkbox", class: "form-check-input"})
        with_tag("label.form-check-label")
      end
      expect(rendered).to have_tag("label.form-check-label", text: list.first.title)
    end
  end

  describe "submit" do
    it do
      expect(helper).to receive(:index_custom_polymorphic_path).with(object_instance.class).and_call_original

      expect(builder.submit).to have_tag("div.btn-group.mr-1") do
        with_tag("input.btn.btn-primary", with: {type: :submit})
        with_tag("a.btn.btn-default.btn-undo-button")
      end
    end
  end
end
