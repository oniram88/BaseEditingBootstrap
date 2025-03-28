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

  describe "#title_new/mod_g" do

  end

  describe "#title_new/mod_g" do
    where(:method, :model, :title) do
      [
        [:title_new_g, User, "Nuovo User"], # Traduzione Standard
        [:title_new_g, Role, "Nuovissimo Role"], # Traduzione con override tramite scope modello
        [:title_mod_g, User, "Modifica User"], # Traduzione Standard
        [:title_mod_g, Role, "Modifica Nuovissimo Role"] # Traduzione con override tramite scope modello
      ]
    end

    with_them do
      it "should " do
        expect(helper.send(method, model)).to be == title
      end
    end
  end

end