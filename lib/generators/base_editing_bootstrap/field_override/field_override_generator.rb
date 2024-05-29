# frozen_string_literal: true

module BaseEditingBootstrap
  module Generators
    class FieldOverrideGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path("../../../../app/views/base_editing", __dir__)
      argument :attributes, type: :array, default: [], banner: "field field:type"

      desc <<-DESCRIPTION.strip_heredoc
             Description:   
                Copy partial files for a defined fields, 
                the possible types are [date,datetime,decimal,integer]
                C'è anche enum, ma per quella dobbiamo fare a mano
      DESCRIPTION
      def copy_form_partials
        if attributes_names.empty?
          say "Need one field"
        else
          attributes.each do |a|
            type = a.type
            type = :base if type == :string
            copy_file "form_field/_#{type}.html.erb", File.join("app/views", plural_name, singular_name, 'form_field', "_#{a.name}.html.erb")
          end
        end

      end
    end
  end
end
