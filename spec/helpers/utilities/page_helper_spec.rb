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

  describe "#new_button" do

    it "no options" do
      expect(helper.new_button("root/test")).to have_tag("a.btn.btn-success.btn-sm", with: {href: "root/test"}) do
        with_tag("i.bi-plus-lg")
      end
    end

    it "override options" do
      expect(helper.new_button("root/test", {class: "example"})).to have_tag("a.example", with: {href: "root/test"})
    end

    it "merged options" do
      expect(helper.new_button("root/test", {title: "example"})).to have_tag("a.btn.btn-success.btn-sm",
                                                                             with: {href: "root/test", title: "example"})
    end
  end

end