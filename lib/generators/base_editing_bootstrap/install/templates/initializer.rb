# frozen_string_literal: true

BaseEditingBootstrap.configure do |config|
  ##
  # Controller da cui derivare poi il BaseEditingController da cui derivano
  # tutti i controller sottostanti
  # @default "ApplicationController"
  #  config.inherited_controller = "ApplicationController"

  ##
  # Configurazione per alterare lo standard di azione post aggiornamento record
  # il default è andare nella pagina di editing del record
  # possibili valori :edit , :index
  # config.after_success_update_redirect = :edit

  ##
  # Configurazione per alterare lo standard di azione post creazione record
  # il default è andare nella pagina di editing del record
  # possibili valori :edit , :index
  # config.after_success_create_redirect = :edit

  ##
  # Classe che rappresenta l'utente, solitamente User
  # config.authentication_model_class= "User"

end
