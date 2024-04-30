# frozen_string_literal: true

BaseEditingBootstrap.configure do |config|
  ##
  # Controller da cui derivare poi il BaseEditingController da cui derivano
  # tutti i controller sottostanti
  # @default "ApplicationController"
  # config_accessor :inherited_controller, default: "ApplicationController"

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