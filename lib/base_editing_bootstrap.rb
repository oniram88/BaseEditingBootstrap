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
loader.setup

module BaseEditingBootstrap
  include ActiveSupport::Configurable

  ##
  # Controller da cui derivare poi il BaseEditingController da cui derivano
  # tutti i controller sottostanti
  # @default "ApplicationController"
  config_accessor :inherited_controller, default: "ApplicationController"
  
  ##
  # Configurazione per alterare lo standard di azione post aggiornamento record
  # il default è andare nella pagina di editing del record
  # possibili valori :edit , :index
  config_accessor :after_success_update_redirect, default: :edit

  ##
  # Configurazione per alterare lo standard di azione post creazione record
  # il default è andare nella pagina di editing del record
  # possibili valori :edit , :index  
  config_accessor :after_success_create_redirect, default: :edit

  def self.deprecator
    @deprecator ||= ActiveSupport::Deprecation.new("1.0", "BaseEditingBootstrap")
  end

end

loader.eager_load
