# frozen_string_literal: true
require 'active_support/concern'

module BaseEditingBootstrap
  module ActionTranslation

    extend ActiveSupport::Concern


    class_methods do
      def human_action_message(action:, successful: true)
        I18n.t(
          "#{base_class.i18n_scope}.#{successful ? "successful" : "unsuccessful"}.messages.#{action}",
          model: base_class.model_name.human
        )
      end
    end
  end
end
