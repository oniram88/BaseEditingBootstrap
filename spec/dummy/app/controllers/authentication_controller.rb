# frozen_string_literal: true

class AuthenticationController < ApplicationController

  private

  def current_user
    @_user ||= User.last
  end

end
