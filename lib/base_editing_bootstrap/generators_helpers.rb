# frozen_string_literal: true

require 'active_support/concern'

module BaseEditingBootstrap::GeneratorsHelpers
  extend ActiveSupport::Concern

  included do

    private
    def class_to_view_path(class_name)
      base_path = ["app/views"]

      base_path << class_name.deconstantize.then { |c| c.underscore.downcase }
      singular_name = class_name.demodulize.underscore.downcase.singularize
      base_path << singular_name.pluralize
      base_path << singular_name
      base_path.compact_blank!
    end

  end

end

