RSpec.shared_examples "a base model" do |ransack_permitted_attributes: [],
  ransack_permitted_associations: [],
  option_label_method: :to_s,
  ransack_permitted_scopes: []|


  let(:option_label_instance){described_class.new}
  it_behaves_like "a validated? object"

  it "human_action_message" do
    expect(described_class).to respond_to(:human_action_message)
  end

  it "have method for belongs_to options" do
    expect(option_label_instance).to respond_to(:option_label)

    expect(option_label_instance).to receive(option_label_method).and_call_original, "Expected `#{option_label_instance.class}#option_label` chiami il metodo `##{option_label_method}` per la traduzione del label nelle options"
    option_label_instance.option_label
  end

  if ransack_permitted_scopes.any?
    it "have scopes" do
      ransack_permitted_scopes.each do |scope|
        expect(described_class).to respond_to(scope)
      end
    end
  end

  ##
  # Oggetto solitamente di classe User che identifichi l'utente a cui eseguire il check dei permessi
  let(:auth_object) { BaseEditingBootstrap.authentication_model }
  let(:new_user_ransack_permitted_attributes) { ransack_permitted_attributes }
  let(:new_user_ransack_permitted_associations) { ransack_permitted_associations }
  let(:new_user_ransack_permitted_scopes) { ransack_permitted_scopes }

  describe "with ransackables" do
    where(:base_model_method, :result, :new_user_result) do
      [
        [
          :ransackable_attributes, ransack_permitted_attributes.map(&:to_s), lazy { new_user_ransack_permitted_attributes.map(&:to_s) }
        ],
        [
          :ransackable_associations, ransack_permitted_associations.map(&:to_s), lazy { new_user_ransack_permitted_associations.map(&:to_s) }
        ],
        [
          :ransackable_scopes, ransack_permitted_scopes.map(&:to_s), lazy { new_user_ransack_permitted_scopes.map(&:to_s) }
        ],
      ]
    end

    with_them do
      subject { described_class.send(base_model_method, inner_auth_object) }

      let(:inner_auth_object) { nil }
      it "new user" do
        expect(Pundit).to receive(:policy).with(an_instance_of(BaseEditingBootstrap.authentication_model),
                                                an_instance_of(described_class)).and_call_original

        is_expected.to match_array(new_user_result)
      end

      context "with auth_object" do
        let(:inner_auth_object) { auth_object }
        it do
          expect(Pundit).to receive(:policy).with(inner_auth_object, an_instance_of(described_class)).and_call_original

          is_expected.to match_array(result)
        end
      end
    end
  end
end

RSpec.shared_examples "a validated? object" do
  subject {
    described_class.new
  }

  it { is_expected.not_to be_validated }

  context "validated" do
    subject { super().tap(&:valid?) }

    it { is_expected.to be_validated }
  end
end

RSpec.shared_examples "a model with custom field_to_form_partial" do |field, partial|

  it "when #{field}" do
    expect(described_class.field_to_form_partial(field)).to eq partial
  end

  it "anything else" do
    expect(described_class.field_to_form_partial(anything)).to be_nil
  end

end