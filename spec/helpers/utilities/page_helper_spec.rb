# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Utilities::PageHelper, type: :helper do

  describe "#boolean_to_icon" do
    where(:value, :matcher) do
      [
        [nil, be_blank],
        [true, have_tag("i.bi-check-lg.text-success")],
        [false, have_tag("i.bi-x-lg.text-danger")],
      ]
    end

    with_them do
      it "should " do
        expect(helper.boolean_to_icon(value)).to(matcher)
      end
    end
  end

end