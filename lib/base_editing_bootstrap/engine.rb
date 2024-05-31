module BaseEditingBootstrap
  class Engine < ::Rails::Engine

    initializer "base_editing_bootstrap.deprecator" do |app|
      app.deprecators[:base_editing_bootstrap] = BaseEditingBootstrap.deprecator
    end

  end
end
