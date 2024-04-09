# frozen_string_literal: true

class RestrictedAreaController < BaseEditingBootstrap.inherited_controller.constantize
  include Pundit::Authorization
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


  # :nocov:
  # Essendo un placeholder per after_action andiamo a non doverlo coprire con il coverage, se viene richiamato fallisce.
  def index
    raise "NOT implemented"
  end

  # :nocov:

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    redirect_back(fallback_location: root_path)
  end
end
