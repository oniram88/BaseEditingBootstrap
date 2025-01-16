# frozen_string_literal: true

module BaseEditingBootstrap::Searches
  ##
  # PORO per la gestione dei metodi associati alla ricerca.
  class Base
    include ActiveModel::Naming
    include ActiveModel::Conversion

    attr_reader :model_klass, :user, :params, :scope, :sorts

    # @param [User] user
    # @param [ActiveRecord::Associations::CollectionProxy] scope
    # @param [Array<String (frozen)>] sort
    def initialize(scope, user, params: {page: nil}, sorts: ["id"])
      @model_klass = scope.klass
      @user = user
      @scope = scope
      @params = params
      @sorts = sorts
    end

    ##
    # Risultato della ricerca, fa da pipeline verso ransack
    # Impostando il sort nel caso in cui non sia già stato impostato da ransack
    def results
      ransack_query
        .tap { |r| r.sorts = @sorts if r.sorts.empty? }
        .result(distinct: true)
        .tap { |q| Rails.logger.debug { "[Ransack] params:#{params} - sql: #{q.to_sql}" } }
        .page(params[:page])
    end

    def ransack_query
      scope
        .ransack(params[:q], auth_object: user)
    end

    def search_fields
      policy.search_fields.collect { |f| Field.new(self, f) }
    end

    def search_result_fields
      policy.search_result_fields
    end

    ##
    # Ritorna se il campo deve essere ordinabile o meno
    def sortable?(field)
      policy.sortable_search_result_fields.include?(field)
    end

    def persisted?
      false
    end

    ##
    # @return [ApplicationPolicy]
    def policy
      Pundit.policy(@user, @model_klass)
    end
  end
end
