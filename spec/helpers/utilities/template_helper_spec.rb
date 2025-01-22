# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Utilities::TemplateHelper, type: :helper do

  describe "#find_template_with_fallbacks" do
    where(:obj, :field, :base_path, :generic_field, :result) do
      [
        # KLAZZ
        [Post, :title, "header_field", "base", "base_editing/header_field/base"],
        [Post, :title, "header_field", "generic_not_found", "base_editing/header_field/base"],

        # OBJ
        [lazy { create(:post) }, :title, "cell_field", "base", "base_editing/cell_field/base"],
        [lazy { create(:post) }, :title, "cell_field", "generic_not_found", "base_editing/cell_field/base"],

        # OBJ with overrides
        [lazy { create(:user) }, :title, "cell_field", "base", "users/user/cell_field/base"],
        [lazy { create(:user) }, :created_at, "cell_field", "timestamps", "users/user/cell_field/timestamps"],

        # OBJ with specific field
        [lazy { create(:user) }, :roles, "form_field", "base", "users/user/form_field/roles"],



      ]
    end

    with_them do

      subject { helper.find_template_with_fallbacks(obj, field, base_path, generic_field) }

      it "should " do
        is_expected.to be == lookup_context.find(result,[],true)
      end
    end
  end

end