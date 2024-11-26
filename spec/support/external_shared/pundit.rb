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

RSpec.shared_examples "a standard base model policy" do |factory, check_default_responses: false|
  let(:user) { create(:user) }
  let(:instance) { described_class.new(user, build(factory)) }

  describe "response to all necessary methods" do
    where(:method) do
      [
        [:sortable_search_result_fields],
        [:search_result_fields],
        [:search_fields],
        [:permitted_associations_for_ransack],
        [:permitted_attributes_for_ransack],
        [:editable_attributes],
        [:permitted_attributes],
      ]
    end

    with_them do
      it "should " do
        expect(instance).to respond_to(method)
      end
    end
  end

  describe "standard_methods" do
    where(:method, :response) do

      if check_default_responses == true
        checks = {
          show: true,
          destroy: true,
          update: true,
          create: true,
          index: true
        }
      elsif check_default_responses == :full_disallow
        checks = {
          show: false,
          destroy: false,
          update: false,
          create: false,
          index: false
        }
      elsif check_default_responses.is_a? Hash
        checks = check_default_responses
      elsif check_default_responses == false
        checks = {}
      else
        raise <<-MESSAGE.strip_heredoc
         Acceptable values for check_default_responses are: 
           - true
           - false
           - :full_disallow -> all methods to false
           - Hash with:  
              show
              destroy
              update
              create
              index
        MESSAGE
      end

      checks.reverse_merge!(
        show: true,
        destroy: true,
        update: true,
        create: true,
        index: true
      )

      [
        [:show?, checks[:show]],
        [:destroy?, checks[:destroy]],
        [:update?, checks[:update]],
        [:create?, checks[:create]],
        [:index?, checks[:index]],
      ]
    end

    with_them do
      it "should respond_to? #{params[:method]}" do
        expect(instance).to respond_to(method)
      end
      if check_default_responses
        it "return value" do
          expect(instance.send(method)).to be == response
        end
      end
    end
  end

end