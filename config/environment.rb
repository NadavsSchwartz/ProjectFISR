require 'bundler/setup'
require 'dotenv/load'

Bundler.require

require_relative '../lib/menu.rb'
require_relative '../lib/model/restaurant_manager.rb'
require_relative '../lib/model/restaurant_api.rb'
require_relative '../lib/model/restaurant.rb'
require_relative '../lib/model/send_email.rb'
