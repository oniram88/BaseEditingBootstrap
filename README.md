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

Aggiungere la dipendenza dai font di font-awesome (vedere se possiamo fare a meno usando icone di bootstrap)
```bash
yarn add  @fortawesome/fontawesome-free
```
aggiungere poi al file css application.bootstrap.scss
```scss
// Font awesome from node_modules
$fa-font-path: ".";
@import '@fortawesome/fontawesome-free/scss/fontawesome';
@import '@fortawesome/fontawesome-free/scss/solid';
@import '@fortawesome/fontawesome-free/scss/regular';
```
e Aggiungere all'inizializzatore degli assets
```ruby
Rails.application.config.assets.paths << Rails.root.join("node_modules/@fortawesome/fontawesome-free/webfonts")
```




## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
