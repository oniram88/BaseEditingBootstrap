# frozen_string_literal: true

module BaseEditingBootstrap
  ##
  # PORO to find the base classe in the BaseEditingController
  class BaseClassFinder
    def initialize(controllar_path)
      @controllar_path = controllar_path
      @_model_class = false
    end

    # @return [NilClass|Object]
    def model
      if @_model_class === false
        @_model_class = nil
        if (anything = @controllar_path.singularize.camelize.safe_constantize)
          @_model_class = anything
        else
          if @controllar_path.include?("/")
            demodulize_one_level = @controllar_path.split("/")[1..].join("/")
            if demodulize_one_level != @controllar_path
              @_model_class = BaseClassFinder.new(demodulize_one_level).model
            end
          end
        end
        @_model_class
      end
    end
  end
end
