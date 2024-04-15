require "ransack"
require "kaminari"
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
  config_accessor :inherited_controller, default: "ApplicationController"

  def self.deprecator
    @deprecator ||= ActiveSupport::Deprecation.new("1.0", "BaseEditingBootstrap")
  end

end

loader.eager_load
