# frozen_string_literal: true

module BaseEditingBootstrap
  module Generators
    class HeaderOverrideGenerator < ::Rails::Generators::Base
      include BaseEditingBootstrap::GeneratorsHelpers

      source_root File.expand_path("../../../../app/views/base_editing", __dir__)
      argument :name, type: :string, banner: "Post", required: true
      argument :attributes, type: :array, default: [], banner: "field field:type"

      TYPES = %i[base]

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
          base_path = class_to_view_path(name)

          attributes.each do |a|
            attr_name, type = a.split(":")

            type = :base if type.nil?
            type = type.to_sym
            raise "Type #{type} not found in #{TYPES}" unless TYPES.include?(type)
            copy_file "header_field/_#{type}.html.erb", File.join(*base_path, 'header_field', "_#{attr_name}.html.erb")
          end
        end

      end
    end
  end
end
