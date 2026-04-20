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

    helper.define_singleton_method(:hidden_attribute?) do |attribute, model = nil, action = nil|
      false
    end

    helper.define_singleton_method(:form_attributes) do |model = nil, action = nil|
      policy(model || obj).editable_attributes
    end
  end

  def render_field(field, readonly: nil)
    described_class.new(helper, form, field, readonly: readonly).render.to_s
  end

  describe 'render output matches expected HTML' do
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
        expect(render_field(:title, readonly: false)).to have_tag(:input, with: {class: 'form-control', type: 'text', name: 'post[title]'})
      end

      it 'timestamps rendering' do
        expect(render_field(:created_at, readonly: false)).to have_tag(:input, with: {class: 'form-control', type: 'datetime-local', name: 'post[created_at]'})
      end

      it 'specific rendering (textarea)' do
        expect(render_field(:description, readonly: false)).to have_tag(:textarea, with: {class: 'form-control', name: 'post[description]'})
      end

      it 'decimal_test_number' do
        expect(render_field(:decimal_test_number, readonly: false)).to have_tag(:input, with: {type: 'number', step: '0.001'})
      end

      it 'rating' do
        expect(render_field(:rating, readonly: false)).to have_tag(:input, with: {type: 'number', step: '0.01'})
      end

      it 'published_at (date)' do
        expect(render_field(:published_at, readonly: false)).to have_tag(:input, with: {type: 'date'})
      end

      it 'read_counter (integer)' do
        expect(render_field(:read_counter, readonly: false)).to have_tag(:input, with: {type: 'number', step: '1'})
      end

      describe 'belongs_to' do
        let!(:user_2) { create(:user) }

        it 'select for belongs_to' do
          expect(render_field(:user, readonly: false)).to have_tag(:select, with: {name: 'post[user_id]'}) do
            with_tag(:option, count: User.count + 1)
            with_tag("option[selected]", with: {value: obj.user_id}, seen: obj.user.username)
            with_tag(:option, with: {value: user_2.id}, seen: user_2.option_label)
            with_tag(:option, with: {value: '', label: ' '})
          end
        end
      end

      describe 'enum fields' do
        it 'string enum' do
          expect(render_field(:category, readonly: false)).to have_tag(:select) do
            with_tag(:option, text: 'News', with: {value: 'news'})
          end
        end

        it 'integer enum' do
          expect(render_field(:priority, readonly: false)).to have_tag(:select) do
            with_tag(:option, text: 'Normal', with: {value: 'normal'})
            with_tag(:option, text: 'Low', with: {value: 'low'})
            with_tag(:option, text: 'Urgent', with: {value: 'urgent'})
          end
        end
      end

      describe 'has_one_attached' do
        subject { render_field(:primary_image, readonly: false) }

        it 'rendered when empty' do
          is_expected.to have_tag(:input, with: {type: 'file'})
          is_expected.not_to have_tag(:input, with: {type: 'hidden', name: 'post[primary_image]'})
          is_expected.not_to have_tag(:button)
          expect(helper.content_for?(:form_field_ending)).to be_falsey
        end

        context 'with an attached image' do
          let(:obj) { create(:post, :with_primary_image) }

          it do
            expect(render_field(:primary_image, readonly: false)).to have_tag(:input, with: {type: 'hidden', name: 'post[primary_image]', value: obj.primary_image.signed_id})
            expect(render_field(:primary_image, readonly: false)).to have_tag(:button) do
              with_tag('i.bi-trash')
            end
            expect(render_field(:primary_image, readonly: false)).to have_tag(:span, seen: obj.primary_image.attachment.blob.filename)
            expect(render_field(:primary_image, readonly: false)).to have_tag(:a, with: {href: url_for(obj.primary_image), target: '_blank'})
            expect(helper.content_for(:form_field_ending)).to have_tag("div##{dom_id(obj, 'preview_image_primary_image')}") do
              with_tag(:img)
            end
          end
        end

        context 'with an attached file not representable?' do
          let(:obj) { create(:post, :with_text_file) }

          it do
            expect(render_field(:primary_image, readonly: false)).to have_tag(:input, with: {type: 'hidden', name: 'post[primary_image]', value: obj.primary_image.signed_id})
            expect(render_field(:primary_image, readonly: false)).to have_tag(:button) do
              with_tag('i.bi-trash')
            end
            expect(render_field(:primary_image, readonly: false)).to have_tag(:span, seen: obj.primary_image.attachment.blob.filename)
            expect(render_field(:primary_image, readonly: false)).to have_tag(:a, with: {href: url_for(obj.primary_image), target: '_blank'})
            expect(helper.content_for?(:form_field_ending)).to be_falsey
          end
        end
      end

      context 'readonly' do
        it 'base rendering readonly' do
          expect(render_field(:title, readonly: true)).to have_tag(:input, with: {class: 'form-control', readonly: 'readonly', value: 'Titolo', name: 'READONLY', disabled: 'disabled'})
        end

        it 'timestamps readonly' do
          expect(render_field(:created_at, readonly: true)).to have_tag(:input, with: {class: 'form-control', type: 'datetime-local', readonly: 'readonly', value: obj.created_at.strftime('%Y-%m-%dT%T'), name: 'READONLY', disabled: 'disabled'})
        end

        it 'specific rendering readonly' do
          expect(render_field(:description, readonly: true)).to have_tag(:textarea, with: {class: 'form-control custom-readonly', name: 'post[description]', readonly: 'readonly'})
        end

        it 'decimal_test_number readonly' do
          expect(render_field(:decimal_test_number, readonly: true)).to have_tag(:input, with: {name: 'READONLY', readonly: 'readonly', disabled: 'disabled', value: '1.123', step: '0.001'})
        end

        it 'rating readonly' do
          expect(render_field(:rating, readonly: true)).to have_tag(:input, with: {name: 'READONLY', readonly: 'readonly', disabled: 'disabled', step: '0.01', value: '9.87654321'})
        end

        it 'published_at readonly' do
          expect(render_field(:published_at, readonly: true)).to have_tag(:input, with: {type: 'date', name: 'READONLY', readonly: 'readonly', disabled: 'disabled', value: obj.published_at.strftime('%Y-%m-%d')})
        end

        it 'read_counter readonly' do
          expect(render_field(:read_counter, readonly: true)).to have_tag(:input, with: {type: 'number', step: '1', readonly: 'readonly'})
        end

        describe 'belongs_to readonly' do
          let!(:user_2) { create(:user) }

          it do
            expect(render_field(:user, readonly: true)).to have_tag(:select, with: {name: 'READONLY', disabled: 'disabled', readonly: 'readonly'}) do
              with_tag('option[selected]', with: {value: obj.user_id}, seen: obj.user.username)
            end
          end
        end

        describe 'enum readonly' do
          it 'string enum readonly' do
            expect(render_field(:category, readonly: true)).to have_tag(:select, with: {name: 'READONLY', disabled: 'disabled', readonly: 'readonly'}) do
              with_tag(:option, text: 'News', with: {value: 'news'})
            end
          end

          it 'integer enum readonly' do
            expect(render_field(:priority, readonly: true)).to have_tag(:select, with: {name: 'READONLY', disabled: 'disabled', readonly: 'readonly'}) do
              with_tag(:option, text: 'Normal', with: {value: 'normal'})
              with_tag(:option, text: 'Low', with: {value: 'low'})
              with_tag(:option, text: 'Urgent', with: {value: 'urgent'})
            end
          end
        end

        describe 'has_one_attached readonly' do
          subject { render_field(:primary_image, readonly: true) }

          it 'rendered when empty' do
            is_expected.to be_empty
          end

          context 'with an attached image' do
            let(:obj) { create(:post, :with_primary_image) }

            it do
              expect(render_field(:primary_image, readonly: true)).to have_tag(:span, seen: obj.primary_image.attachment.blob.filename)
              expect(render_field(:primary_image, readonly: true)).to have_tag(:a, with: {href: url_for(obj.primary_image), target: '_blank'})
              expect(helper.content_for(:form_field_ending)).to have_tag('div') do
                with_tag(:img)
              end
            end
          end

          context 'with an attached file not representable?' do
            let(:obj) { create(:post, :with_text_file) }

            it do
              expect(render_field(:primary_image, readonly: true)).to have_tag(:span, seen: obj.primary_image.attachment.blob.filename)
              expect(render_field(:primary_image, readonly: true)).to have_tag(:a, with: {href: url_for(obj.primary_image), target: '_blank'})
              expect(helper.content_for?(:form_field_ending)).to be_falsey
            end
          end
        end
      end
    end

    context 'red_post with custom form helper' do
      let(:obj) { create(:red_post, title: 'Titolo', description: 'desc') }

      it 'title overridden' do
        expect(render_field(:title, readonly: false)).to have_tag(:textarea, with: {class: 'form-control', name: 'red_post[title]'})
      end

      it 'published_at not overridden' do
        expect(render_field(:published_at, readonly: false)).to have_tag(:input, with: {type: 'date'})
      end
    end

    context 'user model' do
      let(:obj) { create(:user, username: 'dan_osman') }

      it 'override base' do
        # some environments provide an override partial adding an extra class; assert the essential attributes
        expect(render_field(:username, readonly: false)).to have_tag(:input, with: {type: 'text', name: 'user[username]'})
        expect(render_field(:username, readonly: false)).to include('form-control')
      end

      it 'default boolean' do
        expect(render_field(:enabled, readonly: false)).to have_tag('.form-check.form-switch') do
          with_tag("input[type='hidden']", with: {value: 0})
          with_tag("input.form-check-input[type='checkbox']", with: {value: 1})
          with_tag('label.form-check-label', with: {for: 'user_enabled'})
        end
      end

      it 'override timestamp' do
        expect(render_field(:created_at, readonly: false)).to have_tag(:input, with: {class: 'form-control', type: 'datetime-local', name: 'user[created_at]'})
      end
    end

    context 'comment model' do
      let(:obj) { create(:comment) }

      it 'textarea' do
        expect(render_field(:comment, readonly: false)).to have_tag(:textarea, with: {class: 'form-control', name: 'comment[comment]'})
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
        expect(render_field(:example_field, readonly: false)).to have_tag(:input, with: {class: 'form-control', type: 'text', name: 'nome_classe[example_field]'})
      end
    end

    context 'nested_attributes' do
      let(:obj) { create(:company) }

      it 'has has_many nested table rendering' do
        expect(render_field(:addresses, readonly: false)).to have_tag('table', with: {'data-controller' => 'nested-form'})
      end

      it 'has template with NEW_RECORD inputs for nested has_many' do
        html = render_field(:addresses, readonly: false)
        expect(html).to have_tag('template', with: {'data-nested-form-target' => 'template'}) do
          with_tag('tr.nested-form-wrapper#new_address', with: {'data-new-record' => 'true'})
          [:street, :cap, :city].each do |field|
            with_tag('td>input', with: {type: 'text', name: "company[addresses_attributes][NEW_RECORD][#{field}]"})
          end
          with_tag('td>button', with: {'data-action' => 'nested-form#remove'})
          with_tag('td>input', with: {'name' => 'company[addresses_attributes][NEW_RECORD][_destroy]', 'type' => 'hidden', 'value' => 'false'})
        end
      end

      context 'with existing nested elements' do
        let!(:address) { create(:address) }
        let(:obj) { address.addressable }

        it 'renders existing rows' do
          # at least one existing row should be present
          expect(render_field(:addresses, readonly: false)).to have_tag('tbody>tr')
        end
      end

      it 'has has_one nested initialized and renders expected textarea name' do
        html = render_field(:comment, readonly: false)
        expect(html).to have_tag('.form-comment-input-group') do
          with_tag('textarea', with: {name: 'company[comment_attributes][comment]'})
        end
      end

      it 'renders general errors block when object has addresses errors' do
        obj.errors.add(:addresses, 'TOO MANY ADDRESSES')
        obj.errors.add(:addresses, 'Other Error')
        out = render_field(:addresses, readonly: false)
        expect(out).to have_tag('.row>.col-12>.alert.alert-danger', text: /TOO MANY ADDRESSES/)
      end
    end
  end
end
