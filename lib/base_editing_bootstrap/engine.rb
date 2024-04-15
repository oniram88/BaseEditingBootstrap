module BaseEditingBootstrap
  class Engine < ::Rails::Engine

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: 'spec/factories'
    end

    initializer "base_editing_bootstrap.deprecator" do |app|
      app.deprecators[:base_editing_bootstrap] = BaseEditingBootstrap.deprecator
    end

  end
end
