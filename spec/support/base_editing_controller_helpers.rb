def check_if_should_execute(only, except, action)
  return false if except.include?(action)
  return true if only.empty?
  only.include?(action)
end

##
# Helper per testare controller derivanti da base editing
# only e except servono per filtrare o escludere determinate actions
RSpec.shared_examples "base editing controller" do |factory: nil, only: [], except: [], skip_invalid_checks: false|
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
  let(:url_for_new) { [model.new, action: :new] }
  let(:url_for_index) { url_for(model) }
  let(:url_for_create) { [model.new] }
  let(:url_for_succ_delete) { url_for(model) }
  let(:url_for_fail_delete) { url_for_succ_delete }
  let(:url_for_edit) { [persisted_instance, action: :edit] }
  let(:url_for_update) { [persisted_instance, params: {param_key => valid_attributes}] }
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

  it_behaves_like "fail with unauthorized", request: -> { get url_for(url_for_unauthorized) }

  if check_if_should_execute(only, except, :index)
    describe "index" do
      it "response" do
        params = {q: {"foo_eq": "foo"}}
        get url_for_index, params: params
        expect(response).to have_http_status(:ok)
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
        get url_for(url_for_new)
        expect(response).to have_http_status(:ok)
        expect(assigns[:object]).to be_an_instance_of(model)
      end
    end
  end

  if check_if_should_execute(only, except, :edit)
    describe "edit" do
      it "response" do
        get url_for(url_for_edit)
        expect(response).to have_http_status(:ok)
        expect(assigns[:object]).to be_an_instance_of(model)
      end
    end
  end

  if check_if_should_execute(only, except, :update)
    describe "update" do
      it "response" do
        put url_for(url_for_update)
        expect(assigns[:object]).to be_an_instance_of(model)
        expect(response).to have_http_status(:see_other)
      end

      unless skip_invalid_checks
        it "not valid" do
          put url_for([persisted_instance, params: {param_key => invalid_attributes}])
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  if check_if_should_execute(only, except, :create)
    describe "create" do
      it "response" do
        post url_for([*url_for_create, params: {param_key => valid_attributes}])
        expect(assigns[:object]).to be_an_instance_of(model)
        expect(response).to have_http_status(:see_other)
      end

      unless skip_invalid_checks
        it "not valid" do
          post url_for([*url_for_create, params: {param_key => invalid_attributes}])
          expect(response).to have_http_status(:unprocessable_entity)
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
