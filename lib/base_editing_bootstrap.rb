require "ransack"
require "kaminari"
require "kaminari-i18n"
require "pundit"

if ENV['RAILS_ENV'] == 'test' and defined? RSpec
  dir_path = File.expand_path('../spec/support/external_shared', __dir__)
  Dir["#{dir_path}/*.rb"].each do |file|
    require file
  end
end

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/generators")
loader.setup

module BaseEditingBootstrap
    def self.configure
      yield self
    end

  ##
  # Controller da cui derivare poi il BaseEditingController da cui derivano
  # tutti i controller sottostanti
  # @default "ApplicationController"
  mattr_accessor :inherited_controller, default: "ApplicationController"
  
  ##
  # Configurazione per alterare lo standard di azione post aggiornamento record
  # il default è andare nella pagina di editing del record
  # possibili valori :edit , :index
  mattr_accessor :after_success_update_redirect, default: :edit

  ##
  # Configurazione per alterare lo standard di azione post creazione record
  # il default è andare nella pagina di editing del record
  # possibili valori :edit , :index  
  mattr_accessor :after_success_create_redirect, default: :edit

  ##
  # Classe che rappresenta l'utente, solitamente User
  mattr_accessor :authentication_model_class, default: "User"

  def self.authentication_model
    self.authentication_model_class.constantize
  end

  ##
  # Factory per la creazione del modello che rappresenta l'auteticazione
  mattr_accessor :authentication_model_factory, default: :user

  def self.deprecator
    @deprecator ||= ActiveSupport::Deprecation.new("2.0", "BaseEditingBootstrap")
  end

  ##
  # Logger, default to Rails.logger
  mattr_accessor :logger, default: nil

end

loader.eager_load
