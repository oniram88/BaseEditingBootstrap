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

  ##
  # Factory per la creazione del modello che rappresenta l'auteticazione
  # config.authentication_model_factory= :user

  ##
  # Logger, default to Rails.logger
  # @default to Rails.logger or STDOUT if no Rails.logger
  # config.logger = ActiveSupport::TaggedLogging.logger($stdout)
  # config.logger = Rails.logger

end
