# frozen_string_literal: true

module BaseEditingBootstrap
  module Generators
    class ScaffoldGenerator < ::Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      source_root File.expand_path("templates", __dir__)
      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      invoke :model

      def add_base_model
        inject_into_class "app/models/#{model_resource_name}.rb", class_name do
          "  include BaseEditingBootstrap::BaseModel\n"
        end

        template "spec/model.rb", File.join("spec/models", "#{singular_name}_spec.rb")


=begin
        gsub_file "spec/models/#{singular_name}_spec.rb", /pending.*/, ""

        inject_into_file "spec/models/#{singular_name}_spec.rb", before: "end" do
          "  it_behaves_like \"a base model\",
                ransack_permitted_attributes: %w[#{attributes_names.join(" ")}],
                ransack_permitted_associations: []\n"
        end
=end



      end

      def add_controller
        opts = ["--no-helper", "--parent=BaseEditingController"]
        opts << "--force" if options.force?
        generate "controller", controller_class_name, *opts

        route "resources :#{plural_name}"

        template "spec/request.rb", File.join("spec/requests", "#{plural_file_name}_spec.rb")

      end

      def add_policy
        template "policy.rb", File.join("app/policies", "#{singular_name}_policy.rb")
      end


    end
  end
end
