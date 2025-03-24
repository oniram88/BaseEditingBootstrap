require 'rails_helper'
require 'generators/base_editing_bootstrap/install/install_generator'

RSpec.describe BaseEditingBootstrap::Generators::InstallGenerator, type: :generator do
  let(:files) { {
    "app/controllers/application_controller.rb" => "class ApplicationController < ActionController::Base\n\nend",
    "config/application.rb" => "module NamoOfApplication\n\tclass Application < Rails::Application\n\tend\nend"
  } }

  destination File.join(ENGINE_ROOT, "spec/dummy/tmp/generators_spec")

  before(:each) do
    prepare_destination
    # Create files in dummy app
    files.each do |file_name, content|
      file_name = File.join(destination_root, file_name)
      FileUtils.mkdir_p(File.dirname(file_name))
      File.write(file_name, content)
    end
  end

  it "creates a test initializer" do
    generator.create_initializer
    expect(destination_root).to have_structure {
      directory("config") do
        directory("initializers") do
          file("base_editing_bootstrap.rb") do
            contains "BaseEditingBootstrap.configure"
          end
        end
      end
    }
  end

  it "install_and_configure_pundit" do
    expect(generator).to receive(:generate).with("pundit:install")
    generator.install_and_configure_pundit
    assert_file(File.join(destination_root, "app/controllers/application_controller.rb"), /include Pundit::Authorization/)
  end

  it "#prepare_test_environment" do
    expect(generator).to receive(:gem).with("factory_bot_rails", anything)
    expect(generator).to receive(:gem).with('rails-controller-testing', anything)
    generator.prepare_test_environment
  end

  context "when gemfile have already the required gems" do

    let(:files)do
      super().merge(
        "Gemfile"=> <<-RUBY.strip_heredoc
          source "https://rubygems.org"
          
          gem 'factory_bot_rails', group: :test
          group :test do
            gem 'rails-controller-testing'
          end

      RUBY
      )
    end

    it {
      expect(generator).not_to receive(:gem).with("factory_bot_rails", anything)
      expect(generator).not_to receive(:gem).with('rails-controller-testing', anything)
      generator.prepare_test_environment
    }


  end
end