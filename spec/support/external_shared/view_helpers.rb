RSpec.configure do |config|
  # Essendo incluso nel controller, dobbiamo fare in modo che anche nei test di view sia disponibile il field_renderer_class
  config.before(:each, type: :view) do
    view.define_singleton_method(:field_renderer_class) do
      BaseEditingBootstrap::Forms::FieldRenderer
    end
  end

  config.before(:each, type: :helper) do
    without_partial_double_verification do
      helper.define_singleton_method(:field_renderer_class) do |model = nil, action = nil|
        BaseEditingBootstrap::Forms::FieldRenderer
      end
    end
  end

end