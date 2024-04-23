# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Utilities::EnumHelper, type: :helper do

  describe "#enum_translation" do
    let(:params) {
      [
        Post,
        :category,
        :project
      ]
    }
    subject { helper.enum_translation(*params) }

    it { is_expected.to be == "Progetti" }

    context "with variant" do
      let(:params) { super() + [:html] }
      it { is_expected.to be == "Progetti<br>" }

    end

  end

  describe "#enum_collection" do
    let(:params) {
      [
        Post,
        :category
      ]
    }
    subject { helper.enum_collection(*params) }
    it { is_expected.to match({
                                "News" => "news",
                                "Progetti" => "project",
                                "Altro" => "other"
                              }) }

    context "with variant" do
      let(:params) { super() + [:html] }
      it { is_expected.to match({
                                  "News" => "news",
                                  "Progetti<br>" => "project",
                                  "Altro" => "other"
                                }) }
    end
  end

end