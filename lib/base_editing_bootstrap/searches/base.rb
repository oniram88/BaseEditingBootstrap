# frozen_string_literal: true

module BaseEditingBootstrap::Searches
  ##
  # PORO per la gestione dei metodi associati alla ricerca.
  class Base
    include ActiveModel::Naming
    include ActiveModel::Conversion

    attr_reader :model_klass, :user, :params, :scope, :sorts, :distinct, :display_action_column

    # @param [User] user
    # @param [ActiveRecord::Associations::CollectionProxy] scope
    # @param [Array<String (frozen)>] sort
    # @param [TrueClass,FalseClass] display_action_column => visualizzare o meno la colonna delle azioni
    def initialize(scope, user, params: {page: nil}, sorts: ["id"], distinct: true, display_action_column: true)
      @model_klass = scope.klass
      @user = user
      @scope = scope
      @params = params
      @sorts = sorts
      @distinct = distinct
      @display_action_column = display_action_column
    end

    ##
    # Risultato della ricerca, fa da pipeline verso ransack
    # Impostando il sort nel caso in cui non sia già stato impostato da ransack
    def results
      query = ransack_query
      query.sorts = @sorts if query.sorts.empty?

      relation = query.result(distinct: @distinct)
      relation = distinct_order_columns(relation, query.sorts) if @distinct && query.sorts.any?

      relation
        .tap { |q| Rails.logger.debug { "[Ransack] params:#{params} - sql: #{q.to_sql}" } }
        .page(params[:page])
    end

    # PostgreSQL richiede che le colonne usate nell'ORDER BY siano nel SELECT quando DISTINCT è attivo.
    # Aggiungiamo solo le colonne provenienti dalle join, perché la tabella base è già coperta da `table.*`.
    def distinct_order_columns(relation, sorts)
      order_columns = sorts.filter_map do |sort|
        next unless sort.valid?

        attribute = sort.attr
        next unless attribute.respond_to?(:relation) && attribute.respond_to?(:name)

        table_name = attribute.relation.name
        next if table_name.nil? || table_name == model_klass.table_name

        "#{relation.connection.quote_table_name(table_name)}.#{relation.connection.quote_column_name(attribute.name)}"
      end.uniq

      return relation if order_columns.empty?

      relation
        .unscope(:select)
        .select("#{relation.connection.quote_table_name(relation.klass.table_name)}.*", *order_columns)
    end

    private :distinct_order_columns

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
