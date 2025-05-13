require 'rails_helper'
require 'generators/base_editing_bootstrap/header_override/header_override_generator'

RSpec.describe BaseEditingBootstrap::Generators::HeaderOverrideGenerator, type: :generator do
  destination File.join(ENGINE_ROOT, "spec/dummy/tmp/generators_spec")

  before do
    prepare_destination
  end

  describe "Combinations override fields" do
    where(:type, :source) do
      [
        [nil, "_base"],
        ["base", "_base"],
      ]
    end

    with_them do
      it "should create a copy" do
        source_path = File.join(ENGINE_ROOT, "app/views/base_editing/header_field/#{source}.html.erb")
        run_generator ["Post", "title:#{type}"]
        expect(destination_root).to have_structure {
          directory("app/views/posts/post/header_field") do
            file("_title.html.erb") do
              contains File.read(source_path)
            end
          end
        }
      end
    end
  end

  it "should create multiple in one shot" do
    run_generator ["Post", "title", "created_at"]
    expect(destination_root).to have_structure {
      directory("app/views/posts/post/header_field") do
        file("_title.html.erb")
        file("_created_at.html.erb")
      end
    }
  end
  it_behaves_like "generator with correct file paths", file_name: "header_field"

end