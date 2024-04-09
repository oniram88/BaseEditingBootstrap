require "ransack"
require "kaminari"
require "pundit"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module BaseEditingBootstrap
  include ActiveSupport::Configurable
  config_accessor :inherited_controller, default: "ApplicationController"

end

loader.eager_load
