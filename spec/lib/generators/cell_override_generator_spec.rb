require 'rails_helper'
require 'generators/base_editing_bootstrap/cell_override/cell_override_generator'

RSpec.describe BaseEditingBootstrap::Generators::CellOverrideGenerator, type: :generator do
  destination File.join(ENGINE_ROOT, "spec/dummy/tmp/generators_spec")

  before do
    prepare_destination
  end

  describe "Combinations override fields" do
    where(:type, :source) do
      [
        [nil, "_base"],
        ["base", "_base"],
        ["timestamps", "_timestamps"]
      ]
    end

    with_them do
      it "should create a copy" do
        source_path = File.join(ENGINE_ROOT, "app/views/base_editing/cell_field/#{source}.html.erb")
        run_generator ["Post", "title:#{type}"]
        expect(destination_root).to have_structure {
          directory("app/views/posts/post/cell_field") do
            file("_title.html.erb") do
              contains File.read(source_path)
            end
          end
        }
      end
    end
  end

  it "should create multiple in one shot" do
    run_generator ["Post", "title", "created_at:timestamps"]
    expect(destination_root).to have_structure {
      directory("app/views/posts/post/cell_field") do
        file("_title.html.erb")
        file("_created_at.html.erb")
      end
    }
  end

  it "should create correct paths" do
    run_generator ["PostCategory", "title"]
    expect(destination_root).to have_structure {
      directory("app/views/post_categories/post_category/cell_field") do
        file("_title.html.erb")
      end
    }
  end

end