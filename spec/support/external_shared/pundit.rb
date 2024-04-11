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
