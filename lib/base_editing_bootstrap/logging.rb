# frozen_string_literal: true

module BaseEditingBootstrap
  module Logging
    def bs_logger
      @logger ||= begin
                    config_logger = BaseEditingBootstrap.logger
                    config_logger = config_logger || (defined?(Rails) ? Rails.logger : Logger.new($stdout))
                    ActiveSupport::TaggedLogging.new(config_logger).tagged("BASE EDITING BOOTSTRAP")
                  end
    end

  end
end
