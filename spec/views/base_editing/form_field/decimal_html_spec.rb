require "rails_helper"

RSpec.describe "base_editing/form_field", type: :view do

  let(:locals) { {form:, field: :decimal_test_number} }

  let(:obj) { create(:post) }

  let(:form) {
    out = nil
    form_for(obj, url: "#", builder: BaseEditingBootstrap::Forms::Base) do |f|
      out = f
    end
    out
  }

  subject { render(partial: "base_editing/form_field/decimal", locals: locals).to_s }

  it("default scale 2") { is_expected.to have_tag(:input, with: {type: "number", step: "0.01"}) }

  context "scale out of standard html" do
    # Da quello che son riuscito a trovare nella documentazione non vengono gestite più di 14 posizioni decimali
    # 0.000_000_000_000_01
    let(:locals){super().merge(scale:20)}

    it("use html pattern") { is_expected.to have_tag(:input, with: {type: "text", step: "any", pattern: "[0-9]*[.,]?[0-9]{1,20}"}) }

  end


end