require_relative "lib/base_editing_bootstrap/version"

Gem::Specification.new do |spec|
  spec.name = "base_editing_bootstrap"
  spec.version = BaseEditingBootstrap::VERSION
  spec.authors = ["Marino Bonetti"]
  spec.email = ["marinobonetti@gmail.com"]
  spec.summary = "BaseEditing: funzionalità di base per cms rails"
  spec.description = "Raccolta di utility per semplificare costruzione cms in rails"
  spec.homepage = "https://github.com/oniram88/BaseEditingBootstrap"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/oniram88/BaseEditingBootstrap/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*[
          "bin/", "test/", "spec/", "features/",
          ".git", ".gitlab-ci.yml", "appveyor", "Gemfile",
          "cog.toml", "docker-compose.yml", "Dockerfile",
          ".rspec", ".rubocop.yml"
        ])
    end
  end
  spec.files += Dir['spec/support/external_shared/*.rb']

  spec.add_dependency "rails", [">= 7.0", "< 8.1"]
  # Policy
  spec.add_dependency "pundit", ["~> 2.3", ">= 2.3.1"]
  # Search
  spec.add_dependency 'ransack', ['~> 4.0', '>= 4.0.0']
  # Pagination
  spec.add_dependency 'kaminari', ['~> 1.2', '>= 1.2.2']
  spec.add_dependency 'kaminari-i18n', '~> 0.5'

  spec.add_development_dependency "rspec-rails", '~> 7.0'
  spec.add_development_dependency "factory_bot_rails", '~> 6.4'
  spec.add_development_dependency 'faker', '~> 3.3'
  spec.add_development_dependency "puma", '~> 6.4'
  spec.add_development_dependency "sqlite3", '>= 1.7.x'
  spec.add_development_dependency "sprockets-rails", '~> 3.4'
  spec.add_development_dependency 'rails-i18n', '~> 7.0' # For 7.0.0
  spec.add_development_dependency "i18n-debug", '~> 1.2'
  spec.add_development_dependency "cssbundling-rails", '~> 1.4'
  spec.add_development_dependency "rspec-parameterized", "~> 1.0", ">= 1.0.0" # https://github.com/tomykaira/rspec-parameterized
  spec.add_development_dependency 'rspec-html-matchers', '~> 0.10' # https://github.com/kucaahbe/rspec-html-matchers
  spec.add_development_dependency 'rails-controller-testing', '~>1.0'

end
