#!/usr/bin/env ruby
require 'rubygems' rescue nil
$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "..", "lib")
require 'chingu'
include Gosu
require './weird'

$WIDTH = 160
$HEIGHT = 120
$SCALE = 2

def draw_pixels(pixels)
  pixels.each_with_index do |c, i|
    x = (i % $WIDTH)*$SCALE
    y = (i / $WIDTH)*$SCALE
    col = Gosu::Color.new(4278190080 | c.to_i)
    draw_quad(x, y, col, x+$SCALE, y, col, x+$SCALE, y+$SCALE, col, x, y+$SCALE, col)
  end
end

class GameWindow < Chingu::Window
  def initialize
    super $WIDTH*$SCALE, $HEIGHT*$SCALE, false, 100
    self.caption = "Game"

    @timer = Chingu::FPSCounter.new
    @font = Font.new(self, Gosu::default_font_name, 20)
    @screen = Notch::Screen.new($WIDTH, $HEIGHT)
  end

  def button_down(key)
    #puts key if [KbDown,KbUp,KbRight,KbLeft].include? key
  end

  def update()
    @timer.register_tick
    @screen.render(@timer.ticks)
  end

  def draw()
    draw_pixels(@screen.pixels)
    @font.draw("fps: #{@timer.fps}", 10, 10, 3, 1.0, 1.0, 0xffffff00)
  end
end

GameWindow.new.show