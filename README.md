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

Then run installer:
```bash
$ bundle exec rails g base_editing_bootstrap:install
```

**Si presume quindi che ActiveStorage sia correttamente installato, completo del javascript per il direct upload**

### Generators
Then Install dependency (if you run base_editing_bootstrap:install you are good to go):
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

Installare `gem "factory_bot_rails"`

### Initializers
E' possibile configurare BaseEditingBootstrap con alcune impostazioni:
```ruby
  BaseEditingBootstrap.configure do |config|
    ##
    # Controller da cui derivare poi il BaseEditingController da cui derivano 
    # tutti i controller sottostanti
    # @default "ApplicationController"
    # config.inherited_controller = 'ApplicationController'

    ##
    # Configurazione per alterare lo standard di azione post aggiornamento record
    # il default è andare nella pagina di editing del record
    # possibili valori :edit , :index
    # config_accessor :after_success_update_redirect, default: :edit

    ##
    # Configurazione per alterare lo standard di azione post creazione record
    # il default è andare nella pagina di editing del record
    # possibili valori :edit , :index  
    # config_accessor :after_success_create_redirect, default: :edit
  
  end

```

## Usage
Utilizzo per modello base, in questo esempio prendiamo come modello Post come esempio del dummy.

- Creare il Modello ed includere 
  ```ruby
   include BaseEditingBootstrap::BaseModel
  ```
- La factory nelle spec deve contenere il trait `with_invalid_attributes` per definire la situazione di dati per record
  non valido. ES:  
  ```ruby
  trait :with_invalid_attributes do
   name {nil} # name dovrebbe essere obbligatorio nel modello
  end
  ```
- Creare Controller:
  ```ruby
    class PostsController < BaseEditingController
      ##
      # Set default sort order for ransack
      # self.default_sorts= ["id"] 
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
- [OPTIONAL] FORM overrides:
  - nel caso si volesse fare override dei campi della form chiamare il generatore:
    ```shell
    rails g base_editing_bootstrap:field_override ModelName field1 field2:type
    ```
  - è possibile customizzare 
    - un text help per ogni campo andando ad aggiungere nelle traduzioni la relativa 
      traduzione nella posizione: `it.activerecord.attributes.MODEL.FIELD/help_text`
    - un blocco per l'unità di misura accanto al campo aggiungendo alle traduzioni: 
      `it.activerecord.attributes.MODEL.FIELD/unit`
      
- [OPTIONAL] la medesima cosa è possibile fare con il rendering dei campi
  delle celle della tabella
  ```shell
  rails g base_editing_bootstrap:cell_override ModelName field1 field2:type
  ```
- [OPTIONAL] e per fare il rendering dell'header della tabella della index
  ```shell
  rails g base_editing_bootstrap:header_override ModelName field1 field2:type
  ```  
- [OPTIONAL] Base overrides:  
  E' possibile anche fare un override generico dei campi, sono previsti questi tipi di partial
  legati al tipo di dati:  
  **Cell Field**:
  - created_at => timestamps.html.erb
  - updated_at => timestamps.html.erb
  - default    => base.html.erb
  **Form Field**
  - Integer           => _integer.html.erb
  - Float             => _decimal.html.erb
  - Decimal           => _decimal.html.erb
  - DateTime          => _datetime.html.erb
  - Date              => _date.html.erb
  - Boolean           => _boolean.html.erb
  - Enum              => _enum.html.erb
    Per gli enum, le traduzioni dei labels di ogni valore provvengono da i18n
    attraverso l'helper: `Utilities::EnumHelper#enum_translation`
    il quale utilizza il nome dell'attributo con 
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

### Translations
Traduzioni disponibili:  
Per i bottoni della index, è possibile eseguire l'override del testo presente nel bottone. 
Leggere la documentazione nel file `app/helpers/base_editing_helper.rb#translate_with_controller_scoped`


## Testing helpers

### Requirements(installed with generators)
```ruby
group :test do
  gem 'rails-controller-testing'
end
```
### Usage 
Controllers:
```ruby
require 'rails_helper'
RSpec.describe "ServiceControllers", type: :request do
  it_behaves_like "as logged in user" do
    it_behaves_like "base editing controller", factory: :service
  end
end
```
Model:
```ruby
require 'rails_helper'
RSpec.describe Service, type: :model do
  it_behaves_like "a base model",
                  ransack_permitted_attributes: %w[created_at id last_status name stack_id updated_at],
                  ransack_permitted_associations: []
end
```
Policy
```ruby
require 'rails_helper'
##
# - check_default_responses default false, to check default responses
#    
#    on true all are true
#    [:show?, true], 
#    [:destroy?, true],
#    [:update?, true],
#    [:create?, true],
#    [:index?, true],
#
#    when hash keys are:
#    - show
#    - destroy
#    - update
#    - create
#    - index
# 
RSpec.describe ServicePolicy, type: :policy do
  it_behaves_like "a standard base model policy", :service, check_default_responses: false
end
```

## Message translations
I messaggi di generati per il flash provengono dal metodo BaseEditingBootstrap::ActionTranslation.human_action_message  
e seguono una logica simile ad human_attribute_name.  
Sono già presenti i messaggi di default, a cui viene passato il nome del modello,  
ma è possibile fare override del messaggio con la classe: 

```yaml
LANG:
  activerecord:
    successful:
      messages:
        created: "example %{model}"
        updated:
        destroyed:
        CLASS_NAME:
          created: "customized %{model} created"
    unsuccessful:
      messages:
        created: 
        updated: 
```



## Contributing
1. Setup env with:  
```shell
docker compose run app spec/dummy/bin/setup
```

2. Start environment with:  
```shell
docker compose up
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
