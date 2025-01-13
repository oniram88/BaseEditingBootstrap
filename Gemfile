source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in base_editing_bootstrap.gemspec.
gemspec

rails_version = ENV["RAILS_VERSION"] || "default"

rails = case rails_version
        when "master"
          {github: "rails/rails"}
        when "default"
          "~> 7.2.x"
        else
          "~> #{rails_version}"
        end

puts "USE RAILS #{rails.inspect}"

gem "rails", rails

gem "puma", '~> 6.4'

gem "sqlite3"

gem "propshaft", '~> 1.1.0'
gem 'importmap-rails', '~> 2.1.0'
gem "image_processing", "~> 1.2"

gem 'simplecov', require: false, group: :test
gem 'rails-i18n'
gem "generator_spec", '~> 0.10'
gem 'faker', '~> 3.3'
gem "i18n-debug", '~> 1.2'
gem "cssbundling-rails", '~> 1.4'
gem "rspec-parameterized", "~> 1.0", ">= 1.0.0" # https://github.com/tomykaira/rspec-parameterized
gem 'rspec-html-matchers', '~> 0.10' # https://github.com/kucaahbe/rspec-html-matchers
gem 'rails-controller-testing', '~>1.0'
gem "better_errors", group: :development
gem "binding_of_caller", group: :development

# Start debugger with binding.b [https://github.com/ruby/debug]
gem "debug", ">= 1.0.0"
