# frozen_string_literal: true
require 'active_support/concern'

module BaseEditingBootstrap
  module ActionTranslation

    extend ActiveSupport::Concern


    class_methods do

      ##
      # Viene generato un messaggio rispetto all'azione nel caso di successo o fallimento
      # i messaggi seguono la stessa logica del human_attribute_name con inheritance delle classi`
      #
      # {i18n_scope della classe}.{successful|unsuccessful}.messages.{class_name}.{action}
      # {i18n_scope della classe}.{successful|unsuccessful}.messages.{class_ancestors}.{action}
      # {i18n_scope della classe}.{successful|unsuccessful}.messages.{action}
      def human_action_message(action:, successful: true,**options)

       successful_string = successful ? "successful" : "unsuccessful"

        defaults = lookup_ancestors.map do |klass|
          :"#{i18n_scope}.#{successful_string}.messages.#{klass.model_name.i18n_key}.#{action}"
        end

       defaults << options[:default] if options[:default]
       defaults << :"#{base_class.i18n_scope}.#{successful_string}.messages.#{action}"

       options.reverse_merge!(model:base_class.model_name.human)

        I18n.t(
          defaults.shift,
          default: defaults,
          **options
        )
      end
    end
  end
end
