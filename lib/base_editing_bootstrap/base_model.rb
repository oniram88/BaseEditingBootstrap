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
          Pundit.policy(User.new, self.new).permitted_attributes_for_ransack.map(&:to_s)
        end
      end

      def ransackable_associations(auth_object = nil)
        if auth_object
          Pundit.policy(auth_object, self.new).permitted_associations_for_ransack.map(&:to_s)
        else
          Pundit.policy(User.new, self.new).permitted_associations_for_ransack.map(&:to_s)
        end
      end

      def ransackable_scopes(auth_object = nil)
        if auth_object
          Pundit.policy(auth_object, self.new).permitted_scopes_for_ransack.map(&:to_s)
        else
          Pundit.policy(User.new, self.new).permitted_scopes_for_ransack.map(&:to_s)
        end
      end
    end
  end
end
