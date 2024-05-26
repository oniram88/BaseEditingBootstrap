require 'rails_helper'
require 'generators/base_editing_bootstrap/install/install_generator'

RSpec.describe BaseEditingBootstrap::Generators::InstallGenerator, type: :generator do
  destination File.join(ENGINE_ROOT, "spec/dummy/tmp/generators_spec")

  before(:all) do
    prepare_destination
    # Create files in dummy app
    {
      "app/controllers/application_controller.rb" => "class ApplicationController < ActionController::Base\n\nend",
      "config/application.rb" => "module NamoOfApplication\n\tclass Application < Rails::Application\n\tend\nend"
    }.each do |file_name, content|
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
    assert_file(File.join(destination_root, "config/application.rb"), /g.factory_bot dir: 'spec\/factories'/)
  end
end