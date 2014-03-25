require 'chingu'
require 'matrix'
include Gosu
require './gui/screen'

$dimension = 400
$TILE_WIDTH = 48
$TILE_HEIGHT = 24
$size = $dimension / $TILE_WIDTH + 1

module Iso
  class Map
    attr_accessor :map, :window

    def initialize(window, size)
      @window = window
      @map = Matrix.build(4*size, size) do
        Color.new(255, rand(255), rand(255), rand(255))
      end
      return @map
    end

    def draw
      @map.each_with_index do |e, i, j|
        x = j * $TILE_WIDTH
        y = i * $TILE_HEIGHT/2
        if i.odd?
          x += $TILE_WIDTH/2
        end
        put_wobbly_block(x, y, e)
      end
    end

    def put_wobbly_block(x, y, color=Color::WHITE)
      c = color
      top_color = c
      left_color = Color.from_hsv(c.hue, c.saturation, c.value*0.8)
      right_color = Color.from_hsv(c.hue, c.saturation, c.value*0.5)

      y += rand(-2..2)
      w = $TILE_WIDTH
      h = $TILE_HEIGHT
      hw = w/2
      hh = h/2
      v1 = [x, y+hh, top_color]
      v2 = [x+hw, y+h, top_color]
      v3 = [x+w, y+hh, top_color]
      v4 = [x+hw, y, top_color]
      @window.draw_quad(*v1, *v2, *v3, *v4)

      v1 = [x, y+hh, left_color]
      v2 = [x+hw, y+h, left_color]
      v5 = [x, y+hh+h, left_color]
      v6 = [x+hw, y+h+h, left_color]
      @window.draw_quad(*v1, *v5, *v6, *v2)

      v3 = [x+w, y+hh, right_color]
      v2 = [x+hw, y+h, right_color]
      v6 = [x+hw, y+h+h, right_color]
      v7 = [x+w, y+hh+h, right_color]
      @window.draw_quad(*v2, *v6, *v7, *v3)
    end
  end
end

module ZOrder
  Background, Stars, Player, UI = *0..3
end

class GameWindow < Chingu::Window
  def initialize
    super $dimension, $dimension, false, 100
    self.caption = "Game"
    self.input = { :escape => :close }
    # instantiate actors
    @screen = Screen.new($dimension, $dimension, 1)
    @screen.add Iso::Map.new(self, $size)
    @timer = Chingu::FPSCounter.new
    @font = Font.new(self, Gosu::default_font_name, 20)
  end

  def button_down(key) 
    puts key if [KbDown,KbUp,KbRight,KbLeft].include? key
  end
  
  def update() 
    @timer.register_tick
  end
  
  def draw() 
    @screen.draw
    #0.upto(3) do |i|
    #  @map.put_wobbly_block(30+i*2*$TILE_WIDTH,50)
    #  @map.put_wobbly_block(30+i*3*$TILE_WIDTH,130)
    #  @map.put_wobbly_block(30+i*2*$TILE_WIDTH,210)
    #end
    @font.draw("fps: #{@timer.fps}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
  end
end

GameWindow.new.show