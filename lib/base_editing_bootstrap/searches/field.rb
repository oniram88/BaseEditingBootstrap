# frozen_string_literal: true

module BaseEditingBootstrap::Searches
  ##
  # PORO per gestione del singolo campo
  class Field
    attr_reader :search_base, :name

    # @param [BaseEditingBootstrap::Searches::Base] search_base
    # @param [Symbol] name
    def initialize(search_base, name)
      @search_base = search_base
      @name = name
    end

    def to_partial_path
      "search_field"
    end

    ##
    # Helper per estrapolare la label del campo
    # @return [String]
    def label
      @search_base.ransack_query.translate(name)
    end
  end
end
