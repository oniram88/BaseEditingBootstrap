require 'rails_helper'

RSpec.describe Post, type: :model do

  it_behaves_like "a base model",
                  ransack_permitted_attributes: %w[created_at description id title updated_at rating read_counter decimal_test_number published_at category priority user_id editable],
                  ransack_permitted_associations: %w[user],
                  ransack_permitted_scopes: %w[test_scoped_ransack]

  describe "inheritance of overrides custom field_to_form_partial" do

    it "no overrides" do
      expect(Post.field_to_form_partial(:title)).to be_nil
    end

    it "with overrides" do
      expect(RedPost.field_to_form_partial(:title)).to eq :textarea
    end

    it "third level override" do
      third_level_class = Class.new(RedPost)

      third_level_class.set_field_to_form_partial(:title, :checkbox)
      third_level_class.set_field_to_form_partial(:other_field, :text)

      fourth_level_class = Class.new(third_level_class)
      fourth_level_class.set_field_to_form_partial(:title, :date)

      aggregate_failures do
        expect(Post.field_to_form_partial(:title)).to be_nil
        expect(RedPost.field_to_form_partial(:title)).to eq :textarea
        expect(third_level_class.field_to_form_partial(:title)).to eq :checkbox
        expect(fourth_level_class.field_to_form_partial(:title)).to eq :date
        expect(fourth_level_class.field_to_form_partial(:other_field)).to eq :text
      end
    end

  end

  describe "inheritance of overrides accept_nested_attributes_for_order" do

    it "no overrides" do
      expect(Post.accept_nested_attributes_for_order(:imports)).to be_nil
    end

    it "with overrides" do
      subclass = Class.new(Post)
      subclass.set_accept_nested_attributes_for_order(:imports, :ui_ordered)

      expect(subclass.accept_nested_attributes_for_order(:imports)).to eq :ui_ordered
    end

    it "third level override" do
      third_level_class = Class.new(Post)

      third_level_class.set_accept_nested_attributes_for_order(:imports, :ui_ordered)
      third_level_class.set_accept_nested_attributes_for_order(:other_imports, :other_ui_ordered)

      fourth_level_class = Class.new(third_level_class)
      fourth_level_class.set_accept_nested_attributes_for_order(:imports, :new_ui_ordered)

      aggregate_failures do
        expect(Post.accept_nested_attributes_for_order(:imports)).to be_nil
        expect(third_level_class.accept_nested_attributes_for_order(:imports)).to eq :ui_ordered
        expect(fourth_level_class.accept_nested_attributes_for_order(:imports)).to eq :new_ui_ordered
        expect(fourth_level_class.accept_nested_attributes_for_order(:other_imports)).to eq :other_ui_ordered
      end
    end

  end

end
