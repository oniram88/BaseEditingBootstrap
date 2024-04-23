# BaseEditingBootstrap
[![Gem Version](https://badge.fury.io/rb/base_editing_bootstrap.svg)](https://badge.fury.io/rb/base_editing_bootstrap)

WIP

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
### Initializers
E' possibile configurare BaseEditingBootstrap con alcune impostazioni:
```ruby
  BaseEditingBootstrap.configure do |config|
    ##
    # Controller da cui derivare poi il BaseEditingController da cui derivano 
    # tutti i controller sottostanti
    # @default "ApplicationController"
    # config.inherited_controller = 'ApplicationController'
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
- [OPTIONAL] nel caso si volesse fare override dei campi della form:  
  Per il campo che si vuole fare override creare un nuovo file nella cartella 
  del modello `app/views/posts/post/form_field/_NOME_CAMPO.html.erb`  
  al cui interno renderizzare il campo come si preferisce:
  ```erbruby
    <%# locals: (form:, field:) -%>
    <%= form.text_field(field) %>
  ```
- [OPTIONAL] la medesima cosa è possibile fare con il rendering dei campi
  delle celle della tabella della pagina index.  
  La cartella da generare in questo caso sarà: `app/views/posts/post/cell_field/_NOME_CAMPO.html.erb`
  ```erbruby
  <%# locals: (obj:,field:)  -%>
  <td><%= obj.read_attribute(field) %></td>
  ```
- [OPTIONAL] Base overrides:  
  E' possibile anche fare un override generico dei campi, sono previsti questi tipi di partial
  legati al tipo di dati:  
  **Cell Field**:
  - created_at => timestamps.html.erb
  - updated_at => timestamps.html.erb
  - default    => base.html.erb
  **Form Field**
  - Integer          => _integer.html.erb
  - Float            => _decimal.html.erb
  - Decimal          => _decimal.html.erb
  - DateTime         => _detetime.html.erb
  - Date             => _date.html.erb
  - Default/String    => _base.html.erb
  
  In futuro si prevede di aggiungere automatismi per renderizzare senza 
  l'intervento dell'utente dei campi.
- [OPTIONAL] Search Form:  
  Per poter aggiungere una form di ricerca basta aggiungere alla policy
  del modello in questione i campi di ricerca che verranno poi utilizzati da ransack
  per eseguire le ricerche  
  ES:
  ```ruby 
  # file app/policies/post_policy.rb
  #...
  def search_fields
  [:title_i_cont]
  end
  #...
  ```


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
