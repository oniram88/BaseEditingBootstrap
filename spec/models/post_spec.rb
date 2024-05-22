require 'rails_helper'

RSpec.describe Post, type: :model do

  it_behaves_like "a base model",
                  ransack_permitted_attributes: %w[created_at description id title updated_at rating read_counter decimal_test_number published_at category priority],
                  ransack_permitted_associations: []

end
