# frozen_string_literal: true

module BaseEditingBootstrap
  module BaseModel
    extend ActiveSupport::Concern

    included do
      include IsValidated

      def self.ransackable_attributes(auth_object = nil)
        if auth_object
          Pundit.policy(auth_object, self.new).permitted_attributes_for_ransack
        else
          Pundit.policy(User.new, self.new).permitted_attributes_for_ransack
        end
      end

      delegate :ransackable_attributes, :ransackable_associations, to: :@class

      def self.ransackable_associations(auth_object = nil)
        if auth_object
          Pundit.policy(auth_object, self.new).permitted_associations_for_ransack.map(&:to_s)
        else
          Pundit.policy(User.new, self.new).permitted_associations_for_ransack.map(&:to_s)
        end
      end
    end
  end
end
