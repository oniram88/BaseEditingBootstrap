# frozen_string_literal: true

module BaseEditingBootstrap
  module Logging
    def bs_logger
      @logger ||= begin
                    config_logger = BaseEditingBootstrap.logger
                    config_logger || (defined?(Rails) ? Rails.logger : Logger.new($stdout))
                  end
    end

  end
end
