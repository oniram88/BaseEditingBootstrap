# frozen_string_literal: true

module BaseEditingBootstrap
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def create_initializer
        initializer_file_name = "initializer.rb"
        destination = File.join('config', 'initializers', "base_editing_bootstrap.rb")
        template initializer_file_name, destination
      end

      def install_and_configure_pundit
        generate "pundit:install"
        inject_into_class "app/controllers/application_controller.rb", "ApplicationController", "  include Pundit::Authorization\n"
      end

      def prepare_test_environment
        gem "factory_bot_rails", group: :test, version: '~> 6.4', comment: "Necessary for spec"
        gem 'rails-controller-testing', group: :test, comment: "Required if used with controllers spec"
      end
    end
  end
end
