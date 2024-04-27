require 'rails_helper'
require 'generators/base_editing_bootstrap/install/install_generator'

RSpec.describe BaseEditingBootstrap::Generators::InstallGenerator, type: :generator do
  destination File.join(ENGINE_ROOT,"spec/dummy/tmp/generators_spec")

  before(:all) do
    prepare_destination
    run_generator
  end

  it "creates a test initializer" do
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
end