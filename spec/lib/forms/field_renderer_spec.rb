# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BaseEditingBootstrap::Forms::FieldRenderer, type: :helper do
  let(:form) do
    out = nil
    helper.form_for(obj, url: '#', builder: BaseEditingBootstrap::Forms::Base) do |f|
      out = f
    end
    out
  end

  # Helper to build renderer
  before(:each) do
    helper.extend(Utilities::FormHelper)
    helper.extend(Utilities::PageHelper)
    helper.define_singleton_method(:current_user) { nil }
    # Ensure templates located under app/views/base_editing are resolvable when rendering nested partials
    if helper.lookup_context.respond_to?(:prefixes)
      helper.lookup_context.prefixes.unshift('base_editing') unless helper.lookup_context.prefixes.include?('base_editing')
    end

    # minimal implementations of controller helper methods used by templates
    helper.define_singleton_method(:readonly_attribute?) do |attribute, model = nil, action = nil|
      false
    end

    helper.define_singleton_method(:form_attributes) do |model = nil, action = nil|
      policy(model || obj).editable_attributes
    end
  end

  def render_field(field, readonly: nil)
    described_class.new(helper, form, field, readonly: readonly).render.to_s
  end

  describe 'render equivalence with helper.form_print_field' do
    context 'post model' do
      let(:obj) do
        create(:post,
               title: 'Titolo',
               description: 'desc',
               decimal_test_number: 1.123456789,
               rating: 9.87654321,
               published_at: Date.today)
      end

      it 'base rendering (title)' do
        expect(render_field(:title, readonly: false)).to eq helper.form_print_field(form, :title, readonly: false).to_s
      end

      it 'timestamps rendering' do
        expect(render_field(:created_at, readonly: false)).to eq helper.form_print_field(form, :created_at, readonly: false).to_s
      end

      it 'specific rendering (textarea)' do
        expect(render_field(:description, readonly: false)).to eq helper.form_print_field(form, :description, readonly: false).to_s
      end

      it 'decimal_test_number' do
        expect(render_field(:decimal_test_number, readonly: false)).to eq helper.form_print_field(form, :decimal_test_number, readonly: false).to_s
      end

      it 'rating' do
        expect(render_field(:rating, readonly: false)).to eq helper.form_print_field(form, :rating, readonly: false).to_s
      end

      it 'published_at (date)' do
        expect(render_field(:published_at, readonly: false)).to eq helper.form_print_field(form, :published_at, readonly: false).to_s
      end

      it 'read_counter (integer)' do
        expect(render_field(:read_counter, readonly: false)).to eq helper.form_print_field(form, :read_counter, readonly: false).to_s
      end

      describe 'belongs_to' do
        let!(:user_2) { create(:user) }

        it 'select for belongs_to' do
          expect(render_field(:user, readonly: false)).to eq helper.form_print_field(form, :user, readonly: false).to_s
        end
      end

      describe 'enum fields' do
        it 'string enum' do
          expect(render_field(:category, readonly: false)).to eq helper.form_print_field(form, :category, readonly: false).to_s
        end

        it 'integer enum' do
          expect(render_field(:priority, readonly: false)).to eq helper.form_print_field(form, :priority, readonly: false).to_s
        end
      end

      describe 'has_one_attached' do
        subject { render_field(:primary_image, readonly: false) }

        it 'rendered when empty matches helper' do
          expect(subject).to eq helper.form_print_field(form, :primary_image, readonly: false).to_s
        end

        context 'with an attached image' do
          let(:obj) { create(:post, :with_primary_image) }

          it 'matches helper output' do
            expect(render_field(:primary_image, readonly: false)).to eq helper.form_print_field(form, :primary_image, readonly: false).to_s
          end
        end

        context 'with an attached non-representable file' do
          let(:obj) { create(:post, :with_text_file) }

          it 'matches helper output' do
            expect(render_field(:primary_image, readonly: false)).to eq helper.form_print_field(form, :primary_image, readonly: false).to_s
          end
        end
      end

      context 'readonly' do
        it 'base rendering readonly' do
          expect(render_field(:title, readonly: true)).to eq helper.form_print_field(form, :title, readonly: true).to_s
        end

        it 'timestamps readonly' do
          expect(render_field(:created_at, readonly: true)).to eq helper.form_print_field(form, :created_at, readonly: true).to_s
        end

        it 'specific rendering readonly' do
          expect(render_field(:description, readonly: true)).to eq helper.form_print_field(form, :description, readonly: true).to_s
        end

        it 'decimal_test_number readonly' do
          expect(render_field(:decimal_test_number, readonly: true)).to eq helper.form_print_field(form, :decimal_test_number, readonly: true).to_s
        end

        it 'rating readonly' do
          expect(render_field(:rating, readonly: true)).to eq helper.form_print_field(form, :rating, readonly: true).to_s
        end

        it 'published_at readonly' do
          expect(render_field(:published_at, readonly: true)).to eq helper.form_print_field(form, :published_at, readonly: true).to_s
        end

        it 'read_counter readonly' do
          expect(render_field(:read_counter, readonly: true)).to eq helper.form_print_field(form, :read_counter, readonly: true).to_s
        end

        describe 'belongs_to readonly' do
          let!(:user_2) { create(:user) }

          it 'matches helper readonly select' do
            expect(render_field(:user, readonly: true)).to eq helper.form_print_field(form, :user, readonly: true).to_s
          end
        end

        describe 'enum readonly' do
          it 'string enum readonly' do
            expect(render_field(:category, readonly: true)).to eq helper.form_print_field(form, :category, readonly: true).to_s
          end

          it 'integer enum readonly' do
            expect(render_field(:priority, readonly: true)).to eq helper.form_print_field(form, :priority, readonly: true).to_s
          end
        end

        describe 'has_one_attached readonly' do
          subject { render_field(:primary_image, readonly: true) }

          it 'empty is empty' do
            expect(subject).to eq helper.form_print_field(form, :primary_image, readonly: true).to_s
          end

          context 'with an attached image' do
            let(:obj) { create(:post, :with_primary_image) }

            it 'matches helper output' do
              expect(render_field(:primary_image, readonly: true)).to eq helper.form_print_field(form, :primary_image, readonly: true).to_s
            end
          end

          context 'with an attached non-representable file' do
            let(:obj) { create(:post, :with_text_file) }

            it 'matches helper output' do
              expect(render_field(:primary_image, readonly: true)).to eq helper.form_print_field(form, :primary_image, readonly: true).to_s
            end
          end
        end
      end
    end

    context 'red_post with custom form helper' do
      let(:obj) { create(:red_post, title: 'Titolo', description: 'desc') }

      it 'title overridden' do
        expect(render_field(:title, readonly: false)).to eq helper.form_print_field(form, :title, readonly: false).to_s
      end

      it 'published_at not overridden' do
        expect(render_field(:published_at, readonly: false)).to eq helper.form_print_field(form, :published_at, readonly: false).to_s
      end
    end

    context 'user model' do
      let(:obj) { create(:user, username: 'dan_osman') }

      it 'override base' do
        expect(render_field(:username, readonly: false)).to eq helper.form_print_field(form, :username, readonly: false).to_s
      end

      it 'default boolean' do
        expect(render_field(:enabled, readonly: false)).to eq helper.form_print_field(form, :enabled, readonly: false).to_s
      end

      it 'override timestamp' do
        expect(render_field(:created_at, readonly: false)).to eq helper.form_print_field(form, :created_at, readonly: false).to_s
      end
    end

    context 'comment model' do
      let(:obj) { create(:comment) }

      it 'textarea' do
        expect(render_field(:comment, readonly: false)).to eq helper.form_print_field(form, :comment, readonly: false).to_s
      end
    end

    context 'ActiveModel' do
      let(:obj) do
        a = Class.new do
          include ActiveModel::API
          def self.name = 'nome_classe'
          attr_accessor :example_field
        end
        a.new
      end

      it 'render standard fields as text' do
        expect(render_field(:example_field, readonly: false)).to eq helper.form_print_field(form, :example_field, readonly: false).to_s
      end
    end

    context 'nested_attributes' do
      let(:obj) { create(:company) }

      it 'has has_many nested table rendering' do
        expect(render_field(:addresses, readonly: false)).to eq helper.form_print_field(form, :addresses, readonly: false).to_s
      end

      it 'has template with NEW_RECORD inputs for nested has_many' do
        html = render_field(:addresses, readonly: false)
        expect(html).to include('data-nested-form-target="template"')
        expect(html).to include('company[addresses_attributes][NEW_RECORD][street]')
        expect(html).to include('company[addresses_attributes][NEW_RECORD][cap]')
        expect(html).to include('company[addresses_attributes][NEW_RECORD][city]')
      end

      context 'with existing nested elements' do
        let!(:address) { create(:address) }
        let(:obj) { address.addressable }

        it 'renders existing rows' do
          expect(render_field(:addresses, readonly: false)).to eq helper.form_print_field(form, :addresses, readonly: false).to_s
        end

      end

      it 'has has_one nested initialized and renders expected textarea name' do
        html = render_field(:comment, readonly: false)
        expect(html).to eq helper.form_print_field(form, :comment, readonly: false).to_s
        expect(html).to include('name="company[comment_attributes][comment]"')
      end

      it 'renders general errors block when object has addresses errors' do
        obj.errors.add(:addresses, "TOO MANY ADDRESSES, Other Error")
        out = render_field(:addresses, readonly: false)
        expect(out).to eq helper.form_print_field(form, :addresses, readonly: false).to_s
        expect(out).to include('alert alert-danger')
      end

    end
  end
end
