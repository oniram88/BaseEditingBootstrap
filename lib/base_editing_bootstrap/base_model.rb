# frozen_string_literal: true

module BaseEditingBootstrap
  module BaseModel
    extend ActiveSupport::Concern

    included do
      include IsValidated
      include ActionTranslation
      delegate :ransackable_attributes,
               :ransackable_associations,
               :ransackable_scopes, to: :@class

      class_attribute :_field_to_form_partial

      ##
      # Label da utilizzare nelle option per quando si genera le select dei belongs to
      # @return [String,NilClass]
      def option_label
        to_s
      end
    end

    class_methods do
      def ransackable_attributes(auth_object = nil)
        if auth_object
          Pundit.policy(auth_object, self.new).permitted_attributes_for_ransack.map(&:to_s)
        else
          Pundit.policy(BaseEditingBootstrap.authentication_model.new, self.new).permitted_attributes_for_ransack.map(&:to_s)
        end
      end

      def ransackable_associations(auth_object = nil)
        if auth_object
          Pundit.policy(auth_object, self.new).permitted_associations_for_ransack.map(&:to_s)
        else
          Pundit.policy(BaseEditingBootstrap.authentication_model.new, self.new).permitted_associations_for_ransack.map(&:to_s)
        end
      end

      def ransackable_scopes(auth_object = nil)
        if auth_object
          Pundit.policy(auth_object, self.new).permitted_scopes_for_ransack.map(&:to_s)
        else
          Pundit.policy(BaseEditingBootstrap.authentication_model.new, self.new).permitted_scopes_for_ransack.map(&:to_s)
        end
      end

      ##
      # Questo metodo registra sulla classe la tuppla campo e partial per impostare il
      # partial da utilizzare nel rendering
      #
      # E' presente anche un helper per i test:
      #
      #   it_behaves_like "a model with custom field_to_form_partial", :importo, :currency
      #
      def set_field_to_form_partial(field, partial)
        self._field_to_form_partial ||= {}
        self._field_to_form_partial[field] = partial
      end

      def field_to_form_partial(field)
        return nil unless self._field_to_form_partial
        self._field_to_form_partial.fetch(field, nil)
      end

    end
  end
end
