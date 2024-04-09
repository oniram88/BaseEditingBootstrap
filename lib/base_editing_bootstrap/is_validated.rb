# frozen_string_literal: true

require 'active_support/concern'

module BaseEditingBootstrap

  module IsValidated
    extend ActiveSupport::Concern

    included do
      ##
      # Helpers per settare su un record quando abbiamo eseguito o meno la validazione e quindi
      # utilizzare questa informazione nella renderizzazione dello stato della form.
      attr_reader :is_validated
      alias_method :validated?, :is_validated
      after_initialize -> { @is_validated = false }
      after_validation -> { @is_validated = true }
    end
  end
end
