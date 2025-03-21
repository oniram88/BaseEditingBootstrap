class BaseModelPolicy < ApplicationPolicy
  def index? = general_rule

  def create? = general_rule

  def update? = general_rule

  def destroy? = general_rule

  def show? = general_rule

  # Questo metodo può essere anche scritto specifico per azione:
  # - permitted_attributes_for_create
  # - permitted_attributes_for_update
  def permitted_attributes = []

  def editable_attributes = []

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
