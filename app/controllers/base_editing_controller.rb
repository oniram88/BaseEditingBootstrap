class BaseEditingController < RestrictedAreaController
  before_action :load_object, only: [:edit, :show, :update, :destroy]
  helper_method :base_class,
                :destroy_custom_polymorphic_path,
                :edit_custom_polymorphic_path,
                :form_attributes,
                :form_builder,
                :index_custom_polymorphic_path,
                :new_custom_polymorphic_path,
                :show_custom_polymorphic_path

  ##
  # Configure default sort in the index query.
  # Works like documented in https://activerecord-hackery.github.io/ransack/getting-started/sorting/#sorting-in-the-controller
  class_attribute :default_sorts, default: ["id"]

  ##
  # Configure default distinct results in the index query.
  # Works like documented in https://activerecord-hackery.github.io/ransack/going-further/other-notes/#problem-with-distinct-selects
  class_attribute :default_distinct, default: true

  def index
    #se è già stato autorizzano non rieseguiamo, utile nel caso vogliamo sovrascrivere la logica di autorizzazione in inheritance
    authorize base_class unless pundit_policy_authorized?

    q = policy_scope(base_scope)
    @search_instance = search_class.new(q, current_user,
                                        params: params.permit(:page, :q => {}), # FIXME trovare modo per essere più "STRONG"
                                        sorts: default_sorts,
                                        distinct: default_distinct
    )
    @search_instance = yield(@search_instance) if block_given?
  end

  def new
    @object = base_class.new
    @object = yield(@object) if block_given?

    #se è già stato autorizzano non rieseguiamo, utile nel caso vogliamo sovrascrivere la logica di autorizzazione in inheritance
    authorize @object unless pundit_policy_authorized?

    respond_to do |format|
      format.html
    end
  end

  def edit
    @object = yield(@object) if block_given?
  end

  def show
    @object = yield(@object) if block_given?
  end

  def update
    @object = yield(@object) if block_given?
    respond_to do |format|
      if @object.update(permitted_attributes(@object))
        _successful_update(format)
      else
        Rails.logger.debug { "#{base_class} non creato: #{@object.errors.messages.inspect}" }
        _failed_update(format)
      end
    end
  end

  def create
    @object = base_class.new(permitted_attributes)
    @object = yield(@object) if block_given?
    #se è già stato autorizzano non rieseguiamo, utile nel caso vogliamo sovrascrivere la logica di autorizzazione in inheritance
    authorize @object unless pundit_policy_authorized?

    respond_to do |format|
      if @object.save
        _successful_create(format)
      else
        Rails.logger.debug { "#{base_class} non creato: #{@object.errors.messages.inspect}" }
        _failed_create(format)
      end
    end
  end

  def destroy
    @object = yield(@object) if block_given?

    respond_to do |format|
      if @object.destroy
        _successful_destroy(format)
      else
        _failed_destroy(format)
      end
    end
  end

  protected

  def base_class
    return @_base_class if @_base_class
    finder = BaseEditingBootstrap::ResourceFinder.new(controller_path)
    if finder.model
      logger.debug { "Editazione del controller:#{controller_path} per modello: #{finder.model.to_s}" }
    else
      raise "Non riesco a restituire la classe base per il controller #{controller_path}"
    end

    @_base_class = finder.model
  end

  private

  def search_class
    BaseEditingBootstrap::Searches::Base
  end

  def form_builder
    BaseEditingBootstrap::Forms::Base
  end

  def form_attributes(model = base_class.new, action = override_pundit_action_name)
    policy = policy(model)
    method_name = if policy.respond_to?("editable_attributes_for_#{action}")
                    "editable_attributes_for_#{action}"
                  else
                    "editable_attributes"
                  end
    policy.public_send(method_name)
  end

  def load_object
    @object = base_class.find(params[:id])

    #se è già stato autorizzano non rieseguiamo, utile nel caso vogliamo sovrascrivere la logica di autorizzazione in inheritance
    authorize @object unless pundit_policy_authorized?
    logger.debug { "Oggetto #{@object.inspect}" }
  end

  ##
  # Scope iniziale per index, viene passato al policy_scope in index.
  def base_scope
    base_class
  end

  ##
  # Semplice override per avere un debug
  # @param record [ActiveRecord::Base] oggetto per cui estrapolare gli attributi ripuliti, di default utilizza
  #                                    la classe base
  # @param [nil] action
  # @return [Hash{String->Object}]
  def permitted_attributes(record = base_class.new, action = override_pundit_action_name)
    super.tap do |p|
      Rails.logger.debug { "Permitted Attributes: #{pundit_params_for(record).inspect}" }
      Rails.logger.debug { "Parametri puliti [#{action}]: #{p.inspect}" }
    end
  end

  ##
  # In casi in cui l'azione non è quella di pundit per poter ricercarne le policy
  # possiamo fare override, altrimenti il default è l'action_name standard
  def override_pundit_action_name
    action_name
  end

  ##
  # Versione più addolcita del require params, nel caso non sia presente il parametro corretto viene
  # restituito un hash vuoto
  def pundit_params_for(record)
    params.fetch(Pundit::PolicyFinder.new(record).param_key, {})
  end

  def new_custom_polymorphic_path(*base_class)
    new_polymorphic_path(*base_class)
  end

  def edit_custom_polymorphic_path(...)
    edit_polymorphic_path(...)
  end

  def show_custom_polymorphic_path(...)
    polymorphic_path(...)
  end

  def index_custom_polymorphic_path(...)
    polymorphic_path(...)
  end

  def destroy_custom_polymorphic_path(...)
    polymorphic_path(...)
  end

  def _failed_destroy(format)
    format.all {
      redirect_to index_custom_polymorphic_path(base_class),
                  flash: {error: @object.errors.full_messages.join(',')}
    }
  end

  def _successful_destroy(format)
    format.all do
      redirect_to index_custom_polymorphic_path(base_class),
                  status: :see_other,
                  notice: human_action_message(action: :destroyed)
    end
  end

  def _failed_create(format)
    format.html do
      flash.now.alert = human_action_message(action: :created, successful: false)
      render action: :new, status: :unprocessable_entity
    end
  end

  def _successful_create(format)
    format.all do
      path = case BaseEditingBootstrap.after_success_create_redirect
             when :index
               index_custom_polymorphic_path(@object.class)
             else
               edit_custom_polymorphic_path(@object)
             end
      redirect_to path,
                  status: :see_other,
                  notice: human_action_message(action: :created)
    end
  end

  def _failed_update(format)
    format.html do
      flash.now.alert = human_action_message(action: :updated, successful: false)
      render action: :edit, status: :unprocessable_entity
    end
  end

  def _successful_update(format)
    format.all do
      path = case BaseEditingBootstrap.after_success_update_redirect
             when :index
               index_custom_polymorphic_path(@object.class)
             else
               edit_custom_polymorphic_path(@object)
             end
      redirect_to path,
                  status: :see_other,
                  notice: human_action_message(action: :updated)
    end
  end

  delegate :human_action_message, to: :base_class

end
