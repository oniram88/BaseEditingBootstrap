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
      end

      def add_controller
        opts = ["--no-helper", "--parent=BaseEditingController"]
        opts << "--force" if options.force?
        generate "controller", controller_class_name, *opts
        # TODO usare i template ed aggiungere l'esempio della ricerca
        route "resources :#{plural_name}"

        template "spec/request.rb", File.join("spec/requests", "#{plural_file_name}_spec.rb")

      end

      def add_policy
        @search_attrs = []
        @permitted_attributes = []
        if yes? "Vuoi poter ricercare determinati campi con form di ricerca?(y/n)"

          say "Gli attributi che hai indicato sono: #{ attributes_names.join(",")}"
          say <<~MESSAGE
            La ricerca avviene tramite le logiche di ransack.
            Puoi trovare la documentazione dei predicati di ricerca qua: 
            https://activerecord-hackery.github.io/ransack/getting-started/search-matches/
            Ecco alcuni esempi di possibili modi di ricercare:
          MESSAGE

          matchers = {
            "_eq":"Equal",
            "_not_eq":"Not equal",
            "_i_cont":"Contains insensitive",
          }

          out =  [["",*matchers.values]]
          attributes_names.each do |attr|
            out << [attr, *matchers.keys.collect{|m| "#{attr}#{m}"  } ]
          end

          print_table(out,borders:true)
          @search_attrs = ask("Inserisce un elenco diviso da virgola degli attributi da ricercare").split(",")
          #cerchiamo di estrapolare gli attributi da rendere disponibili a ransack per la ricerca
          @permitted_attributes = out.select{|c|  c[1..].intersect?(@search_attrs)  }.collect(&:first)
          puts @permitted_attributes.inspect
        end

        template "policy.rb", File.join("app/policies", "#{singular_name}_policy.rb")
        template "spec/policy.rb", File.join("spec/policies", "#{singular_name}_policy_spec.rb")

      end


    end
  end
end
