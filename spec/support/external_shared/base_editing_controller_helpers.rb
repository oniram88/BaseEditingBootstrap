##
# Condiviso con applicazione esterna

def check_if_should_execute(only, except, action)
  return false if except.include?(action)
  return true if only.empty?
  only.include?(action)
end

##
# Helper per testare controller derivanti da base editing
# only e except servono per filtrare o escludere determinate actions
# @!attribute factory [Symbol] -> nome della factory da usare per il modello
# @!attribute only [Array[Symbol]] -> nome delle sole action da controllare
#         - delete
#         - create
#         - update
#         - edit
#         - new
#         - index
# @!attribute expect [Array[Symbol]] -> nome delle action da non controllare
# @!attribute skip_invalid_checks [Boolean] -> se serve saltare il check delle azioni con dati non validi
# @!attribute skip_authorization_check [Boolean] -> se skippare controllo delle autorizzazioni nel caso non siano azioni non autorizzabili
#
# Sono poi disponibili diversi let per poter fare l'override arbitrario degli url,
# tutti abbastanza auto-descrittivi
# 
# :url_for_new
# :url_for_index
# :url_for_create
# :url_for_succ_delete
# :url_for_fail_delete
# :url_for_edit             ->  Rispetto  agli altri questo risulta essere pià complicato in quanto
#                               deve ritornare una proc a cui passiamo il valore dell'istanza persistente
#                               che nei casi del after create non abbiamo a priori.
# :url_for_unauthorized
# :url_for_update
#
#
RSpec.shared_examples "base editing controller" do |factory: nil, only: [], except: [], skip_invalid_checks: false, skip_authorization_check: false|
  if factory
    let(:inside_factory) { factory }
  else
    let(:inside_factory) { "to override inside_factory" }
  end
  let(:persisted_instance) do
    create(inside_factory)
  end

  ##
  # Possibili override per la costruzione delle path
  #
  let(:url_for_new) { url_for([model.new, action: :new]) }
  let(:url_for_index) { url_for(model) }
  let(:url_for_create) { url_for(model.new) }
  let(:url_for_succ_delete) { url_for(model) }
  let(:url_for_fail_delete) { url_for_succ_delete }
  let(:url_for_edit) { ->(p = persisted_instance) {
    url_for([p, action: :edit])
  } }
  let(:url_for_update) { url_for(persisted_instance) }
  ## non sempre abbiamo l'index nelle action disponibili, dobbiamo quindi avere modo di eseguire un override
  let(:url_for_unauthorized) { url_for_index }
  ##
  # Chiave dentro a params
  let(:param_key) {
    Pundit::PolicyFinder.new(model).param_key
  }

  let(:model) {
    persisted_instance.class
  }

  let(:invalid_attributes) {
    attributes_for(inside_factory, :with_invalid_attributes)
  }

  let(:valid_attributes) {
    nested_attributes_for(inside_factory)
  }

  unless skip_authorization_check
    it_behaves_like "fail with unauthorized", request: -> { get url_for(url_for_unauthorized) }
  end

  if check_if_should_execute(only, except, :index)
    describe "index" do
      it "response" do
        params = {q: {"foo_eq": "foo"}}
        get url_for_index, params: params
        expect(response).to have_http_status(200)
        expect(assigns[:search_instance]).to be_an_instance_of(BaseEditingBootstrap::Searches::Base).and(have_attributes(
                                                                                                           user: user,
                                                                                                           params: ActionController::Parameters.new(params).permit!
                                                                                                         ))
      end
    end
  end

  if check_if_should_execute(only, except, :new)
    describe "new" do
      it "response" do
        get url_for_new
        expect(response).to have_http_status(200)
        expect(assigns[:object]).to be_an_instance_of(model)
      end
    end
  end

  if check_if_should_execute(only, except, :edit)
    describe "edit" do
      it "response" do
        get url_for_edit.call
        expect(response).to have_http_status(200)
        expect(assigns[:object]).to be_an_instance_of(model)
      end
    end
  end

  if check_if_should_execute(only, except, :update)
    describe "update" do
      it "response" do
        put url_for_update, params: {param_key => valid_attributes}
        expect(assigns[:object]).to be_an_instance_of(model)
        expect(response).to have_http_status(303)
        case BaseEditingBootstrap.after_success_update_redirect
        when :index
          expect(response).to redirect_to(url_for_index)
        else
          # edit
          expect(response).to redirect_to(url_for_edit.call(assigns[:object]))
        end
        expect(flash[:notice]).not_to be_blank
      end

      unless skip_invalid_checks
        it "not valid" do
          put url_for_update, params: {param_key => invalid_attributes}
          expect(response).to have_http_status(422)
        end
      end
    end
  end

  if check_if_should_execute(only, except, :create)
    describe "create" do
      it "response" do
        post url_for_create, params: {param_key => valid_attributes}
        expect(assigns[:object]).to be_an_instance_of(model)
        expect(response).to have_http_status(303)
        case BaseEditingBootstrap.after_success_create_redirect
        when :index
          expect(response).to redirect_to(url_for_index)
        else
          # edit
          expect(response).to redirect_to(url_for_edit.call(assigns[:object]))
        end
        expect(flash[:notice]).not_to be_blank
      end

      unless skip_invalid_checks
        it "not valid" do
          post url_for_create, params: {param_key => invalid_attributes}
          expect(response).to have_http_status(422)
        end
      end
    end
  end

  if check_if_should_execute(only, except, :delete)
    describe "delete" do
      it "response" do
        delete url_for(persisted_instance)
        expect(assigns[:object]).to be_an_instance_of(model)
        expect(response).to redirect_to(url_for_succ_delete)
        expect(flash[:notice]).not_to be_blank
      end

      it "not valid" do
        allow_any_instance_of(model).to receive(:destroy) do |obj|
          obj.errors.add(:base, :indestructible)
          false
        end
        delete url_for(persisted_instance)
        expect(response).to redirect_to(url_for_fail_delete)
        expect(flash[:error]).not_to be_blank
      end
    end
  end
end

default_unathorized_failure = -> { raise "TODO - passare proc con richiesta che dovrà fallire" }

RSpec.shared_examples "fail with unauthorized" do |request: default_unathorized_failure|
  it "is expected to redirect to root" do

    if Gem::Version.create( Pundit::VERSION) < Gem::Version.create('2.3.2')
      allow(Pundit).to receive(:authorize).with(user, any_args).and_raise(Pundit::NotAuthorizedError)
    else
      allow_any_instance_of(Pundit::Context).to receive(:authorize).and_raise(Pundit::NotAuthorizedError)
    end

    instance_exec(&request)
    expect(response).to redirect_to(root_path)
    expect(flash[:error]).not_to be_nil
  end
end

