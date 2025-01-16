# frozen_string_literal: true

class AuthenticationController < ApplicationController

  private

  def current_user
    @_user ||= Thread.current[:current_user]
  end

end
