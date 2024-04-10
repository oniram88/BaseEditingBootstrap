require "ransack"
require "kaminari"
require "pundit"

if ENV['RAILS_ENV'] == 'test'
  require File.expand_path('../spec/support/base_editing_controller_helpers.rb', __dir__)
end

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module BaseEditingBootstrap
  include ActiveSupport::Configurable
  config_accessor :inherited_controller, default: "ApplicationController"

end

loader.eager_load
