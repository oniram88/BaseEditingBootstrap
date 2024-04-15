# frozen_string_literal: true

module BaseEditingBootstrap::Searches
  ##
  # PORO per la gestione dei metodi associati alla ricerca.
  class Base
    include ActiveModel::Naming
    include ActiveModel::Conversion

    attr_reader :model_klass, :user, :params, :scope

    # @param [User] user
    # @param [ActiveRecord::Associations::CollectionProxy] scope
    def initialize(scope, user, params: {page: nil})
      @model_klass = scope.klass
      @user = user
      @scope = scope
      @params = params
    end

    ##
    # Risultato della ricerca, fa da pipeline verso ransack
    def results
      ransack_query
        .result(distinct: true)
        .order(:id)
        .page(params[:page])
    end

    def ransack_query
      scope
        .ransack(params[:q], auth_object: user)
    end

    def search_fields
      Pundit.policy(@user, @model_klass).search_fields.collect { |f| Field.new(self, f) }
    end

    def search_result_fields
      Pundit.policy(@user, @model_klass).search_result_fields
    end

    def persisted?
      false
    end
  end
end
