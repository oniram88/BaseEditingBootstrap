RSpec.shared_examples "generator with correct file paths" do |file_name:|
  describe "should create correct paths" do
    where(:class_name, :field, :full_path) do
      [
        ["PostCategory", "title", "app/views/post_categories/post_category/#{file_name}"],
        ["Customers::PostCategory", "title", "app/views/customers/post_categories/post_category/#{file_name}"],
      ]
    end

    with_them do
      it "should " do
        destination_path = full_path
        run_generator [class_name, field]
        expect(destination_root).to have_structure {
          directory(destination_path) do
            file("_title.html.erb")
          end
        }
      end
    end
  end
end