require 'pundit/matchers'

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
  let(:user) { create(BaseEditingBootstrap.authentication_model_factory) }
  let(:instance) { described_class.new(user, build(factory)) }

  describe "response to all necessary methods" do
    where(:method) do
      [
        [:sortable_search_result_fields],
        [:search_result_fields],
        [:search_fields],
        [:permitted_associations_for_ransack],
        [:permitted_attributes_for_ransack],
        [:permitted_scopes_for_ransack],
        [:editable_attributes],
        [:permitted_attributes],
        [:attribute_is_readonly],
      ]
    end

    with_them do
      it "should " do
        expect(instance).to respond_to(method)
      end
    end
  end

  # Controllo che se negli elementi dei #sortable_search_result_fields è presente un elemento
  # che ha come prefisso il nome di una relazione presente in #permitted_associations_for_ransack
  # allora nella policy della relativa associazione dovrò trovare in #permitted_attributes_for_ransack
  # il nome della colonna da ordinare.
  # ES:
  # relazione: User -> Post
  # class PostPolicy
  #   def sortable_search_result_fields = %i[user_username]
  #   def permitted_associations_for_ransack = %i[user]
  # end
  # class UserPolicy
  #   def permitted_attributes_for_ransack = %[username]
  # end
  # ordinamento per #user_username, quindi devo cercare relazione in `user` e attribute `username`
  it "check associated sortable attributes" do
    klass = instance.record.class
    # non facciamo nulla se non è un active record il record da controllare
    if klass.respond_to?(:reflect_on_association)

      # escludiamo le colonne del modello
      col_to_check = (instance.sortable_search_result_fields.collect(&:to_s) - instance.record.class.column_names).uniq

      elenco_campi_ordinabili_in_relazione = col_to_check.map do |field|
        instance.permitted_associations_for_ransack.map do |rel|
          if field.match(/^#{rel}_(.*)$/)
            [rel, Regexp.last_match(1)]
          end
        end
      end.flatten(1).compact.uniq

      elenco_campi_ordinabili_in_relazione.each do |relation, field|
        reflection = klass.reflect_on_association(relation.to_s)
        policy = Pundit.policy(instance.user, reflection.class_name.constantize.new)
        expect(policy.permitted_attributes_for_ransack.collect(&:to_sym).include?(field.to_sym)).to be_truthy, lambda {
          "Mi aspetto che `#{policy.class.name}#permitted_attributes_for_ransack` includa `#{field}` per permettere l'ordinamento del campo tramite relazione"
        }
      end

    end
  end

  describe "standard_methods" do
    where(:method, :response) do

      if check_default_responses == true
        checks = {} # will be setted to permit_al_actions
      elsif check_default_responses == :full_disallow
        checks = {} # will be setted to forbid_al_actions
      elsif check_default_responses.is_a? Hash
        checks = check_default_responses
      elsif check_default_responses == false
        checks = {}
      else
        raise <<-MESSAGE.strip_heredoc
         Acceptable values for check_default_responses are: 
           - true -> is like permit_al_actions
           - false -> don't check
           - :full_disallow -> is like forbid_al_actions
           - Hash with key value:  
              show => boolean
              destroy => boolean
              update => boolean
              create => boolean
              index => boolean
              ...custom => boolean
        MESSAGE
      end

      checks.reverse_merge!(
        show: true,
        destroy: true,
        update: true,
        create: true,
        index: true
      )

      checks.collect{|k,v| [ :"#{k}?",v ]}
    end

    with_them do
      it "should respond_to? #{params[:method]}" do
        expect(instance).to respond_to(method)
      end

      case check_default_responses
      when :full_disallow
        it { expect(instance).to forbid_all_actions }
      when true
        it { expect(instance).to permit_all_actions }
      when false
        # nothing
      else
        it "return value" do
          expect(instance.send(method)).to be == response
        end
      end
    end
  end

end