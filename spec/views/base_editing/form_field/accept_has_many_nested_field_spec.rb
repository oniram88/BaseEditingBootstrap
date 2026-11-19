require "rails_helper"

RSpec.describe "base_editing/form_field", type: :view do

  let(:company) { create(:company) }
  let(:form) {
    out = nil
    form_for(company, url: "#", builder: BaseEditingBootstrap::Forms::Base) do |f|
      out = f
    end
    out
  }
  let(:locals) {
    {
      form:,
      field: :addresses,
      new_object: build(:address, addressable: company)
    }
  }

  before do
    create(:address, addressable: company, street: "Zebra Street")
    create(:address, addressable: company, street: "Alpha Street")

    allow(company.class).to receive(:accept_nested_attributes_for_order)
      .with(:addresses)
      .and_return(:ui_ordered)
    company.addresses.define_singleton_method(:ui_ordered) { order(:street) }

    allow(view).to receive(:policy).and_return(double(editable_attributes: [:street]))
    allow(view).to receive(:form_print_field) { |nested_form, field| nested_form.object.public_send(field) }
    allow(view).to receive(:error_messages_for).and_return("")
    allow(view).to receive(:icon).and_return("")
  end

  subject { render(partial: "base_editing/form_field/accept_has_many_nested_field", locals: locals).to_s }

  it "renders existing nested records in the configured order" do
    rows = Nokogiri::HTML.fragment(subject).css("tbody > tr.nested-form-wrapper")

    expect(rows.map { |row| row.at_css("td").text.strip }).to eq ["Alpha Street", "Zebra Street"]
  end

end
