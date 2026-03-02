module BaseEditingBootstrap
  class Engine < ::Rails::Engine

    initializer "base_editing_bootstrap.deprecator" do |app|
      app.deprecators[:base_editing_bootstrap] = BaseEditingBootstrap.deprecator
    end

    initializer "base_editing_bootstrap.importmap", before: "importmap" do |app|
      app.config.importmap.paths << Engine.root.join("config/importmap.rb")
    end

    initializer "base_editing_bootstrap.assets.precompile" do |app|
      app.config.assets.precompile << "nested_form_controller.js"
    end

  end
end
