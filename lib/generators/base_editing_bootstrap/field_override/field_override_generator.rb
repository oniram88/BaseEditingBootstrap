# frozen_string_literal: true

module BaseEditingBootstrap
  module Generators
    class FieldOverrideGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../../../../app/views/base_editing", __dir__)
      argument :name, type: :string, banner: "Post", required: true
      argument :attributes, type: :array, default: [], banner: "field field:type"

      desc <<-DESCRIPTION.strip_heredoc
             Description:   
                Copy partial files for a defined fields, 
                the possible types are [string,date,datetime,decimal,integer,enum]
                Default to string
      DESCRIPTION

      def copy_form_partials
        if attributes.empty?
          say "Need one field"
        else
          plural_name = name.downcase.singularize.pluralize
          singular_name = name.downcase.singularize
          attributes.each do |a|
            attr_name, type = a.split(":")

            type = :base if type.to_s.to_sym == :string
            type = :base if type.nil?
            copy_file "form_field/_#{type}.html.erb", File.join("app/views", plural_name, singular_name, 'form_field', "_#{attr_name}.html.erb")
          end
        end

      end
    end
  end
end
