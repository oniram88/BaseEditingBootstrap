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

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/oniram88/BaseEditingBootstrap"
  spec.metadata["changelog_uri"] = "https://github.com/oniram88/BaseEditingBootstrap/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .gitlab-ci.yml appveyor Gemfile])
    end
  end
  spec.files += Dir['spec/support/external_shared/*.rb']

  spec.add_dependency "rails", ">= 7.0"
  spec.add_dependency "pundit", ">= 2.3.1"

  # Search
  spec.add_dependency 'ransack', '>= 4.0.0'
  # Pagination
  spec.add_dependency 'kaminari', '>= 1.2.2'

  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "factory_bot_rails"

end
