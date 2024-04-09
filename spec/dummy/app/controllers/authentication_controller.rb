# frozen_string_literal: true

class AuthenticationController < ApplicationController

  private

  def current_user
    User.new
  end

end
