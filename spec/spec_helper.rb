require 'vending_machine'
require 'factory_bot'
require 'pry'

RSpec.configure do |config|
  config.color = true
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end
end