# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Utilities::SearchHelper, type: :helper do

  describe '#search_form_buttons' do
    let(:model_klass) { User }
    let(:search_object) { double(klass: model_klass) }
    let(:ransack_form) { double(object: search_object) }
    let(:buttons) do
      helper.search_form_buttons(ransack_form)
      view.content_for(:search_form_buttons)
    end

    before do
      def helper.index_custom_polymorphic_path(*_args)
        '/custom/index/path'
      end

      allow(ransack_form).to receive(:submit) do |label, options|
        helper.tag.input(type: 'submit', value: label, class: options[:class])
      end
    end

    context 'when the object defines specific translations' do
      let(:model_klass) { Post }

      it 'uses object specific translations when available' do
        I18n.backend.store_translations(:it, {
                                          activerecord: {
                                            attributes: {
                                              'post/search_buttons': {
                                                search: 'Cerca posts',
                                                clear_search: 'Pulisci posts'
                                              }
                                            }
                                          }
                                        })

        I18n.with_locale(:it) do
          expect(buttons).to have_tag('input.btn.btn-primary', with: {type: 'submit', value: 'Cerca posts'})
          expect(buttons).to have_tag('a.btn.btn-secondary', text: 'Pulisci posts', with: {href: '/custom/index/path'})
        end
      end
    end

    context 'when the object does not define specific translations' do
      it 'falls back to the default translations' do
        I18n.with_locale(:it) do
          expect(buttons).to have_tag('input.btn.btn-primary', with: {type: 'submit', value: 'Esegui ricerca'})
          expect(buttons).to have_tag('a.btn.btn-secondary', text: 'Cancella ricerca', with: {href: '/custom/index/path'})
        end
      end
    end
  end

  describe "#render_cell_field" do

    context "post model" do
      let(:obj) { create(:post, :other, title: "Titolo", description: "desc") }

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

      it "enum category" do
        expect(helper.render_cell_field(obj, :category)).to have_tag(:td, text: "Altro")
      end
    end

    context "user model" do
      let(:enabled) { nil }
      let(:obj) { create(:user, username: "dan_osman", enabled:) }

      it "with override base" do
        expect(helper.render_cell_field(obj, :username)).to have_tag(:td, with: {class: "override"}, text: "dan_osman")
      end

      describe "boolean field" do
        context "with enabled true" do
          let(:enabled) { true }
          it "render ok" do
            expect(helper.render_cell_field(obj, :enabled)).to have_tag(:td) do
              with_tag("i.bi-check-lg.text-success")
            end
          end
        end
        context "with enabled false" do
          let(:enabled) { false }
          it "render ok" do
            expect(helper.render_cell_field(obj, :enabled)).to have_tag(:td) do
              with_tag("i.bi-x-lg.text-danger")
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