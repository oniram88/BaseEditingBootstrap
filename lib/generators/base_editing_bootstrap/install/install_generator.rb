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
        actual_gemfile_path = File.join(@destination_stack, "Gemfile")
        if File.exist?(actual_gemfile_path)
          actual_gemfile = File.read(File.join(@destination_stack, "Gemfile"))
        else
          actual_gemfile = ''
        end
        unless actual_gemfile =~ /factory_bot_rails/
          gem "factory_bot_rails", group: :test, version: '~> 6.4', comment: "Necessary for spec"
        end
        unless actual_gemfile =~ /rails-controller-test/
          gem 'rails-controller-testing', group: :test, comment: "Required if used with controllers spec"
        end
      end
    end
  end
end
