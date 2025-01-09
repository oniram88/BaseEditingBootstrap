RSpec.shared_examples "a base model" do |ransack_permitted_attributes: [], ransack_permitted_associations: []|

  it_behaves_like "a validated? object"

  it "human_action_message" do
    expect(described_class).to respond_to(:human_action_message)
  end

  ##
  # Oggetto solitamente di classe User che identifichi l'utente a cui eseguire il check dei permessi
  let(:auth_object) { :auth_object }
  let(:new_user_ransack_permitted_attributes) { ransack_permitted_attributes }
  let(:new_user_ransack_permitted_associations) { ransack_permitted_associations }

  describe "with ransackables" do
    where(:base_model_method, :result, :new_user_result) do
      [
        [
          :ransackable_attributes, ransack_permitted_attributes.map(&:to_s), ref(:new_user_ransack_permitted_attributes)
        ],
        [
          :ransackable_associations, ransack_permitted_associations.map(&:to_s), ref(:new_user_ransack_permitted_associations)
        ],
      ]
    end

    with_them do
      subject { described_class.send(base_model_method, inner_auth_object) }

      let(:inner_auth_object) { nil }
      it "new user" do
        expect(Pundit).to receive(:policy).with(an_instance_of(User),
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
