# frozen_string_literal: true

module BaseEditingBootstrap
  module Generators
    class ScaffoldGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)
      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      invoke :model

      def add_base_model
        puts model_resource_name
        puts class_name
        inject_into_class "app/models/#{model_resource_name}.rb", class_name do
          "  include BaseEditingBootstrap::BaseModel\n"
        end
        generate "controller", class_name.pluralize, "--no-helper", "--parent=BaseEditingController"
      end

    end
  end
end
