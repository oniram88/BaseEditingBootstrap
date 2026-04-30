class BaseModelPolicy < ApplicationPolicy
  def index? = general_rule

  def create? = general_rule

  def update? = general_rule

  def destroy? = general_rule

  def show? = general_rule

  # Questo metodo può essere richiamato specifico per azione:
  # - permitted_attributes_for_create
  # - permitted_attributes_for_update
  # - permitted_attributes_for_ACTION_NAME
  # Quindi nella policy possiamo differenziare le due situazioni
  def permitted_attributes = []

  # Questo metodo può essere richiamato specifico per azione:
  # - editable_attributes_for_create
  # - editable_attributes_for_update
  # - editable_attributes_for_ACTION_NAME
  # Quindi nella policy possiamo differenziare le due situazioni
  def editable_attributes = []

  ##
  # Permette di specificare se un attributo è di sola lettura durante il rendering della form.
  # Oltre alla versione standard è possibile definire il metodo specificando il tipo di azione con il
  # medesimo formato utilizzato negli altri metodi:
  # - attribute_is_readonly_for_create?
  # - attribute_is_readonly_for_update?
  # - attribute_is_readonly_for_ACTION_NAME?
  #
  # @param attribute [Symbol] nome dell'attributo
  # @param action_name [String] nome dell'azione
  # @return [Boolean] true se l'attributo è di sola lettura, false altrimenti
  def attribute_is_readonly(_attribute) = false

  ##
  # Permette di specificare se un attributo deve essere trattato come hidden durante il rendering della form.
  # Analogamente a attribute_is_readonly è possibile definire la versione specifica per azione:
  # - attribute_is_hidden_for_create?
  # - attribute_is_hidden_for_update?
  # - attribute_is_hidden_for_ACTION_NAME?
  #
  # @param attribute [Symbol] nome dell'attributo
  # @param action_name [String] nome dell'azione
  # @return [Boolean] true se l'attributo è hidden (deve essere renderizzato come hidden_field), false altrimenti
  def attribute_is_hidden(_attribute) = false

  def permitted_attributes_for_ransack
    record.class.column_names + record.class._ransackers.keys
  end

  def permitted_associations_for_ransack
    []
  end

  def permitted_scopes_for_ransack = []

  def search_fields = []

  def search_result_fields = []

  ##
  # List of attributes in index to make it sortable
  def sortable_search_result_fields
    search_result_fields
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private

  def general_rule
    true
  end
end
