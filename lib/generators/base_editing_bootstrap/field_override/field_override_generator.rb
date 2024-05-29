# frozen_string_literal: true

module BaseEditingBootstrap
  module Generators
    class FieldOverrideGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path("../../../../app/views/base_editing", __dir__)
      argument :attributes, type: :array, default: [], banner: "field field:type"

      desc "copy partial files for a defined fields, the possible types are [date,datetime,decimal,enum,integer]"

      def copy_form_partials
        raise "Need one field" if attributes_names.empty?
        attributes.each do |a|
          type = a.type
          type = :base if type == :string
          copy_file "form_field/_#{type}.html.erb", File.join("app/views", plural_name, singular_name, 'form_field', "_#{a.name}.html.erb")
        end
      end

    end
  end
end
