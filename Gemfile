source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in base_editing_bootstrap.gemspec.
gemspec

rails_version = ENV["RAILS_VERSION"] || "default"

ransack_version = ENV["RANSACK_VERSION"] || nil

# se la versione rails passata non ha il terzo numero di versione, lo aggiungo per evitare problemi con le dipendenze
rails_version = rails_version.split(".").tap { |v| v << "0" if v.size < 3 }.join(".")

rails = case rails_version
        when "master"
          {github: "rails/rails"}
        when "default"
          "~> 7.2.x"
        else

          ##
          # Le versioni di ransack devono essere maggiori di 4.0.0
          # teniamo allineate le versioni con le versioni di ransack presenti al momento in cui viene rilasciata la
          # versione di rails. Lavoriamo solamente con versioni di Rails in linea con la matrix tenendo conto
          # solo della minor release partendo dalla versione 7.1
          # volendo possiamo configurare con una variabile d'ambiente la versione di ransack da utilizzare,
          # in modo che possiamo definire speciali combinazioni di versioni di ransack e rails.
          #
          # | Rails | Ransack |
          # |-------|---------|
          # | 7.1   | 4.0     |
          # | 7.2   | 4.0     |
          # | 8.0   | 5.0     |
          # | 8.1   | 6.0     |

          unless ransack_version
            ransack_version = case rails_version
                              when /^7\.1\./
                                "4"
                              when /^7\.2\./
                                "4"
                              when /^8\.0\./
                                "5"
                              when /^8\.1\./
                                "6"
                              else
                                6
                              end
          end

          "~> #{rails_version}"
        end

puts "USE RAILS #{rails.inspect} - RANSACK #{ransack_version.inspect}"

gem "rails", rails

gem "puma", '~> 6.4'

gem "sqlite3"

gem "propshaft", '~> 1.1.0'
gem 'importmap-rails', '~> 2.1'
gem "image_processing", "~> 1.2"

gem 'simplecov', require: false, group: :test
gem 'rails-i18n'
gem 'i18n', "!= 1.15.0"
gem "generator_spec", '~> 0.10'
gem 'faker', '~> 3.3'
gem "i18n-debug", '~> 1.2'
gem "cssbundling-rails", '~> 1.4'
gem "rspec-parameterized", "~> 1.0", ">= 1.0.0" # https://github.com/tomykaira/rspec-parameterized
gem 'rspec-html-matchers', '~> 0.10' # https://github.com/kucaahbe/rspec-html-matchers
gem 'rails-controller-testing', '~>1.0'
gem "better_errors", group: :development
gem "binding_of_caller", group: :development

gem "ransack", "~> #{ransack_version}.0"

## Aggiunto per visualizzare validazioni
gem 'active_storage_validations'

# Start debugger with binding.b [https://github.com/ruby/debug]
gem "debug", ">= 1.0.0"
