RSpec.shared_examples "a validated? object" do
  subject {
    # prendiamo un modello a caso per testare questa  cosa
    described_class.new
  }

  it { is_expected.not_to be_validated }

  context "validated" do
    subject { super().tap(&:valid?) }

    it { is_expected.to be_validated }
  end
end
