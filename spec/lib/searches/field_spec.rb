# frozen_string_literal: true

require 'rails_helper'

module BaseEditingBootstrap
  RSpec.describe Searches::Field do
    let(:search_base) { Searches::Base.new(Post.all, create(:post)) }
    subject(:instance) { described_class.new(search_base, :title_i_cont) }

    it { expect(instance.to_partial_path).to be == "search_field" }

    it { expect(instance.label).to eq "Titolo contiene" }
  end
end
