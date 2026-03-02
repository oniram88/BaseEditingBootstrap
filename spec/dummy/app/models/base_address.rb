# frozen_string_literal: true

class BaseAddress < ApplicationRecord
  include BaseEditingBootstrap::BaseModel

  belongs_to :addressable, polymorphic: true

  validates :street, presence: true

end
