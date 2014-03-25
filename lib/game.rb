$: << File.dirname(__FILE__)
require 'chingu'
include Gosu

require 'colors'
require 'iso'
require 'ui'

require 'loot_machine'
require 'unit_machine'

require 'game_window'

GameWindow.new.show