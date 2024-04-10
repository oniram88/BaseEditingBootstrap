# BaseEditingBootstrap
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "base_editing_bootstrap"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install base_editing_bootstrap
```

### TODO generators
Then Install dependency (WIP TO TRANSLATE IN INSTALLATION TASK):
```bash

bundle exec rails g pundit:install
```
Aggiungere ad ApplicationController 
```ruby
  include Pundit::Authorization
```

Installare bootstrap e questo dipende dal sistema scelto di assets bundling.  
La versione più semplice è attraverso: https://github.com/rails/cssbundling-rails  
Una volta installato basta lanciare bin/rails css:install:bootstrap come da
documentazione e avrete la vostra versione di boostrap installata.

Installare `gem "factory_bot_rails"` e configurarlo correttamente in application.rb
```ruby
config.generators do |g|
  g.test_framework :rspec
  g.fixture_replacement :factory_bot
  g.factory_bot dir: 'spec/factories'
end
```
## Usage
Utilizzo per modello base, in questo esempio prendiamo come modello Post come esempio del dummy.

- Creare il Modello ed includere `include BaseEditingBootstrap::BaseModel`
- Creare Controller:
  ```ruby
    class PostsController < BaseEditingController
    end
  ```
- Aggiungere la rotta: `resources :posts`
- Creare la policy:
  ```ruby
  class PostPolicy < BaseModelPolicy
  
  def editable_attributes
  [
  :title,
  :description
  ]
  end
  
  def permitted_attributes
  [
  :title,
  :description
  ]
  end
  
  def search_result_fields
  [:title]
  end
  end

  ```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
