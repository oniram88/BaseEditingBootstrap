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
        [:password_field, :input, {type: "password"}],
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
    it "with custom base classes" do
      expect(builder.form_style_class_for(:username, base_classes: ["custom-base-class", "other-base-class"])).to be == "custom-base-class other-base-class"
    end
    context "with errors" do
      let(:object_instance) { super().tap { |u| u.errors.add(:username, :invalid) } }
      it "default" do
        expect(builder.form_style_class_for(:username)).to be == "form-control is-invalid"
      end
      it "with override" do
        expect(builder.form_style_class_for(:username, {class: "custom_class"})).to be == "form-control is-invalid custom_class"
      end
      it "with relationable column" do
        expect(builder.form_style_class_for(:username_id)).to be == "form-control is-invalid"
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

    context "field not valid" do
      let(:object_instance) { super().tap { |u| u.errors.add(:only_false_virtual, :invalid) } }
      it {
        expect(builder.select(:only_false_virtual, [])).to have_tag("select.form-control.form-select.is-invalid")
      }
      it "con altre opzioni della select" do
        expect(builder.select(:only_false_virtual, [], include_blank: true)).to have_tag("select.form-control.form-select.is-invalid")
      end
    end

    context "field is a relation with id" do
      let(:object_instance) { super().tap { |u| u.errors.add(:only_false_relation, :invalid) } }
      # Se stiamo renderizzando un campo select il quale punterà probabilmente ad una relazione, potremmo aver assegnato
      # l'errore di validazione alla relazione piuttosto che alla colonna con *_id, quindi dovremmo visualizzare
      # l'errore cercando anche nella variante del metodo senza _id
      it { expect(builder.select(:only_false_relation_id, [])).to have_tag("select.form-control.form-select.is-invalid") }
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
    context "field not valid" do
      let(:object_instance) { super().tap { |u| u.errors.add(:only_false_virtual, :invalid) } }
      it {
        expect(builder.check_box(:only_false_virtual)).to have_tag(".form-check.is-invalid") do
          with_tag("input[type='checkbox'].form-check-input.is-invalid")
        end
      }
    end
  end

  describe "switch_box" do
    it do
      expect(builder).to receive(:check_box).with(:username, include(class: "form-check form-switch"), "1", "0")
      builder.switch_box(:username)
    end
    it "con classe custom" do
      expect(builder).to receive(:check_box).with(:username, include(class: "form-check form-switch custom_class"), "1", "0")
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
    it "con classe custom per checkbox" do
      expect(builder.collection_check_boxes(:posts, list, :id, :title,
                                            {}, {form_check_class: "custom-class"})).to have_tag("div.form-check.custom-class")
    end
    it "con multiple custom class per checkbox" do
      expect(builder.collection_check_boxes(:posts, list, :id, :title,
                                            {}, {form_check_class: "custom-class other-class "})).to have_tag("div.form-check.custom-class.other-class")
    end
  end

  describe "submit" do
    it do
      expect(helper).to receive(:index_custom_polymorphic_path).with(object_instance.class).and_call_original

      expect(builder.submit).to have_tag("div.btn-group.mr-1") do
        with_tag("input.btn.btn-primary", with: {type: :submit, value: "Crea User"})
        with_tag("a.btn.btn-default.btn-undo-button", text: "Annulla")
      end
    end

    it "with full override of value" do
      expect(builder.submit("MANUAL OVERRIDE")).to have_tag("div.btn-group.mr-1 > input.btn.btn-primary", with: {type: :submit, value: "MANUAL OVERRIDE"})
    end

    describe "check variants" do
      where(:case_name, :object_instance, :result) do
        [
          ["Standard persiste object", lazy { create(:user) }, "Aggiorna User"],
          ["change text from inheritance and i18n", lazy { RedPost.new }, "Esegui Red post"],
          ["change text from inheritance and i18n persisted", lazy { create(:red_post) }, "RiEsegui Red post"],
        ]
      end

      with_them do
        it "should " do
          expect(builder.submit).to have_tag("div.btn-group.mr-1 > input.btn.btn-primary", with: {type: :submit, value: result})
        end
      end
    end

    context "in a translation context without key for a overriden class" do
      let(:object_instance) { RedPost.new }
      it "fallback on standard rails" do
        I18n.with_locale(:zzz) do
          expect(builder.submit).to have_tag("div.btn-group.mr-1 > input.btn.btn-primary", with: {type: :submit, value: "Create Red post"})
        end
      end
    end

    context "object not derived from ::ActiveRecord::Base" do
      let(:object_instance) {
        b = Class.new do
          include ActiveModel::API
        end
        Object.const_set("FakeBaseClass", b)
        Object.const_set("InheritedFakeBaseClass", Class.new(b)).new #new finale per avere l'istanza della classe
      }

      it {
          expect(builder.submit).to have_tag("div.btn-group.mr-1 > input.btn.btn-primary", with: {type: :submit, value: "Crea Inherited fake base class"})
      }

    end

  end
end
