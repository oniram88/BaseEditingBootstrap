module BaseEditingHelper
  include Utilities::PageHelper
  include Utilities::EnumHelper
  include Utilities::SearchHelper
  include Utilities::FormHelper
  include Utilities::IconHelper

  ##
  # Estrapola la traduzione, andando ad includere la path del controller nella ricerca della chiave
  # Viene tenuto conto anche del namespace del controller assieme ai suoi namespace
  # ES:
  # In un caso in cui abbiamo un controller di questo tipo: Customer::PostsController < PostsController
  # la ricerca della chiave .destroy partendo dal partial app/views/base_editing/_search_result_buttons.html.erb
  # sarà così composta:
  #
  #   it.customer/posts.index.base_editing.search_result_buttons.destroy => nil
  #   it.customer/posts.base_editing.search_result_buttons.destroy => nil
  #   it.posts.index.base_editing.search_result_buttons.destroy => nil
  #   it.posts.base_editing.search_result_buttons.destroy => nil
  #   it.base_editing.index.base_editing.search_result_buttons.destroy => nil
  #   it.base_editing.base_editing.search_result_buttons.destroy => nil
  #   it.restricted_area.index.base_editing.search_result_buttons.destroy => nil
  #   it.restricted_area.base_editing.search_result_buttons.destroy => nil
  #   it.authentication.index.base_editing.search_result_buttons.destroy => nil
  #   it.authentication.base_editing.search_result_buttons.destroy => nil
  #   it.base_editing.search_result_buttons.destroy => nil
  #
  def translate_with_controller_scoped(key, **options)
    if key&.start_with?(".")
      inner_key = scope_key_by_partial(key)
      defaults = []
      paths = controller.class.ancestors.select { |c| c < ApplicationController }.collect(&:controller_path).uniq
      paths.each do |path|
        defaults << [:"#{path}.#{action_name}.#{inner_key}", :"#{path}.#{inner_key}"]
      end
      defaults << inner_key.to_sym
      defaults << options[:default] if options.key?(:default)
      key = nil
      options[:default] = defaults.flatten
    end

    # dobbiamo eliminare possibili duplicati nello scope delle chiavi
    t(key, **options)
  end

end
