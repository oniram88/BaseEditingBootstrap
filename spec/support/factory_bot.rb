require 'factory_bot_rails'

FactoryBot.definition_file_paths << File.join(File.dirname(__FILE__), 'factories')
FactoryBot.factories.clear
FactoryBot.find_definitions

##
# Helper per la generazione dati per la creazione di un hash utile alla creazione di un record
# completo di associazioni
module FactoryBot::Syntax::Methods
  def nested_attributes_for(*args)
    attributes = attributes_for(*args)
    klass = FactoryBot::Internal.factory_by_name(args.first).build_class

    klass.reflect_on_all_associations(:belongs_to).each do |r|
      association = FactoryBot.create(r.class_name.underscore)
      attributes[:"#{r.name}_id"] = association.id
      attributes[:"#{r.name}_type"] = association.class.name if r.options[:polymorphic]
    end

    attributes
  end
end


RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
