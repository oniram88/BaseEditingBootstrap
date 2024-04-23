# frozen_string_literal: true

module Utilities
  module EnumHelper
    # @param [BaseModel] model class
    # @param [Symbol] attribute
    # @param [nil|String] variant
    def enum_collection(model, attribute, variant = nil)
      model.send(attribute.to_s.pluralize(2).to_sym).collect { |key, val|
        [enum_translation(model, attribute, key, variant), key]
      }.to_h
    end

    # @param [BaseModel] model class
    # @param [Symbol] attribute
    # @param [Symbol|nil] value
    # @param [nil|String] variant
    def enum_translation(model, attribute, value, variant = nil)
      return '' if value.nil?
      variant = "_#{variant}" unless variant.nil?
      model.human_attribute_name(
        "#{attribute}.#{value}#{variant}",
        default: model.human_attribute_name("#{attribute}.#{value}")
      )
    end
  end
end
