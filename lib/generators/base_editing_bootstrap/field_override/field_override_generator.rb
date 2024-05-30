# frozen_string_literal: true

module BaseEditingBootstrap
  module Generators
    class FieldOverrideGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../../../../app/views/base_editing", __dir__)
      argument :name, type: :string, banner: "Post", required: true
      argument :attributes, type: :array, default: [], banner: "field field:type"

      TYPES = %i[base date datetime decimal integer enum]

      desc <<-DESCRIPTION.strip_heredoc
             Description:   
                Copy partial files for a defined fields, 
                the possible types are #{TYPES}
                Default to base
      DESCRIPTION

      def copy_form_partials
        if attributes.empty?
          say "Need one field"
        else
          singular_name = name.underscore.downcase.singularize
          plural_name = singular_name.pluralize
          attributes.each do |a|
            attr_name, type = a.split(":")

            type = :base if type.nil?
            type = type.to_sym
            raise "Type #{type} not found in #{TYPES}" unless TYPES.include?(type)
            copy_file "form_field/_#{type}.html.erb", File.join("app/views", plural_name, singular_name, 'form_field', "_#{attr_name}.html.erb")
          end
        end

      end
    end
  end
end
