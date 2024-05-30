require 'rails_helper'
require 'generators/base_editing_bootstrap/field_override/field_override_generator'

RSpec.describe BaseEditingBootstrap::Generators::FieldOverrideGenerator, type: :generator do
  destination File.join(ENGINE_ROOT, "spec/dummy/tmp/generators_spec")

  before do
    prepare_destination
  end

  describe "Combinations override fields" do
    where(:type, :source) do
      [
        [nil, "_base"],
        ["string", "_base"],
        ["date", "_date"],
        ["datetime", "_datetime"],
        ["decimal", "_decimal"],
        ["enum", "_enum"],
        ["integer", "_integer"]
      ]
    end

    with_them do
      it "should create a copy" do
        source_path = File.join(ENGINE_ROOT, "app/views/base_editing/form_field/#{source}.html.erb")
        run_generator ["Post", "title:#{type}"]
        expect(destination_root).to have_structure {
          directory("app/views/posts/post/form_field") do
            file("_title.html.erb") do
              contains File.read(source_path)
            end
          end
        }
      end
    end
  end

  it "should create multiple in one shot" do
    run_generator ["Post", "title", "name:date", "created_at:datetime"]
    expect(destination_root).to have_structure {
      directory("app/views/posts/post/form_field") do
        file("_title.html.erb")
        file("_name.html.erb")
        file("_created_at.html.erb")
      end
    }
  end

end