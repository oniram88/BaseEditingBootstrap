RSpec::Matchers.define :permit_editable_attributes do |*expected_attributes|
  description { "to permit editable attributes:#{expected_attributes}" }
  failure_message { "'#{actual}' does not permit attributes #{expected_attributes - actual.editable_attributes}" }
  match do |actual|
    actual_attributes = expected_attributes - actual.editable_attributes

    actual_attributes.empty?
  end
  match_when_negated do |actual|
    actual_attributes = expected_attributes & actual.editable_attributes

    actual_attributes.empty?
  end
end

shared_examples "a standard policy" do |factory|
  let(:user) { create(:user) }
  let(:instance) { described_class.new(user, build(factory)) }

  describe "standard_methotds" do
    where(:method, :response) do
      [
        [:show?, false],
        [:destroy?, true],
        [:update?, true],
        [:create?, true],
        [:index?, true],
      ]
    end

    with_them do
      it "should " do
        expect(instance).to respond_to(method)
      end
      it "return value" do
        expect(instance.send(method)).to be == response
      end
    end
  end

end