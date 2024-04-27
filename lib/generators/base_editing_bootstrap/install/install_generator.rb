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
    end
  end
end
