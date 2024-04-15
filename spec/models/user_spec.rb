require 'rails_helper'

RSpec.describe User, type: :model do

  it_behaves_like "a base model",
                  ransack_permitted_attributes: %i[username],
                  ransack_permitted_associations: %w[posts]

end
