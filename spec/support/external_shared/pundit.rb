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