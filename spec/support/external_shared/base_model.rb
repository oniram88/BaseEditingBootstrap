
RSpec.shared_examples "a base model" do |ransack_permitted_attributes:[],ransack_permitted_associations:[]|

  it_behaves_like "a validated? object"

  describe "ransackables" do
    where(:base_model_method, :policy_method, :result) do
      [
        [
          :ransackable_attributes, :permitted_attributes_for_ransack, ransack_permitted_attributes
        ],
        [
          :ransackable_associations, :permitted_associations_for_ransack, ransack_permitted_associations
        ]
      ]
    end

    with_them do
      describe ".ransackable_attributes" do
        subject { described_class.send(base_model_method, auth_object) }

        let(:simulated_user_instance) { instance_double("User") }
        # before do
        #   allow(User).to receive(:new).and_return(simulated_user_instance)
        # end
        let(:auth_object) { nil }
        let(:policy) {
          instance_double("BaseModelPolicy", policy_method => result)
        }
        it "new user" do
          expect(Pundit).to receive(:policy).with(an_instance_of(User),
                                                  an_instance_of(described_class)).and_call_original
          #.and_return(policy)

          is_expected.to match_array(result)
        end

        context "with auth_object" do
          let(:auth_object) { :auth_object }
          it do
            expect(Pundit).to receive(:policy).with(auth_object, an_instance_of(described_class)).and_call_original
            # .and_return(policy)

            is_expected.to match_array(result)
          end
        end
      end
    end
  end
end


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
