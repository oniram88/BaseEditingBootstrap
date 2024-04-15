require 'factory_bot_rails'

FactoryBot.definition_file_paths << File.join(File.dirname(__FILE__), '../factories')
FactoryBot.factories.clear
FactoryBot.find_definitions
